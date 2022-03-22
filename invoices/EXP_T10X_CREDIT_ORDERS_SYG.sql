PROCEDURE EXP_T10X_CREDIT_ORDERS_SYG(PI_PROGR_H          IN NUMBER,
                                       PI_SESSION_ID       IN NUMBER,
                                       PI_DOCUMENTKEY      IN VARCHAR2,
                                       PI_MASSIVE_EXP_DATE IN DATE,
                                       PI_CODDIV           IN VARCHAR2,
                                       PO_MSG              OUT VARCHAR,
                                       PO_STATUS           OUT NUMBER) IS
    --
    -- Cursor on main Order table
    --
    CURSOR CL_T100 IS
      SELECT T100.*, TA0300.CODSALESMAN
        FROM T100ORDHEAD T100
      
        LEFT JOIN TA0300SELLINGDAY TA0300
          ON TA0300.CODDIV = T100.CODDIV
         AND TA0300.IDDAY = T100.IDDAY
		WHERE T10.IDSESSION = PI_SESSION_ID
	  
       ORDER BY T100.NUMORD, T100.CODUSR ASC;

    --
    -- Rows
    --
    CURSOR CL_T106(CI_NUMORD NUMBER, CI_CODUSR VARCHAR2) IS
      SELECT T106.*,
             T060.DESART || '/' || T060.DESART2 PRODUCTDES
        FROM T106ORDROW T106
        
        JOIN T060ARTICLE T060
          ON T060.CODART = T106.CODART
         AND T060.CODDIV = T106.CODDIV
        
       WHERE T106.NUMORD = CI_NUMORD
         AND T106.CODUSR = CI_CODUSR
         AND T106.CODTYPROW IN ('0', '1')
         AND T106.QTYORD > 0;

    -- -----------------------------------------
    -- Cursor on main Customer table T100ORDHEAD where records are locked by another user
    -- -----------------------------------------
    CURSOR CL_LOCKED_T100 IS
      SELECT NUMORD, CODUSR, DTELCK, CODUSRLCK
        FROM ZQEXP_T100CREDITORDER_SYG_C
       WHERE IDSESSIONLCK IS NOT NULL
         AND IDSESSIONLCK != PI_SESSION_ID
         AND DOCUMENTKEY = nvl(PI_DOCUMENTKEY, DOCUMENTKEY)
         AND NVL(DTEMOD, DTECRE) >
             NVL(PI_MASSIVE_EXP_DATE, NVL(DTETOHOST, C_SM1_NULL_DATE))
       ORDER BY NUMORD, CODUSR ASC;
    --
    VL_MESSAGE_H VARCHAR2(2000) := 'Error while exporting ORDERS T10X';
    VL_MESSAGE_D VARCHAR2(2000) := NULL;
    --
    VL_PROGR_D_T100    NUMBER := 0;
    VL_COUNT_XOUT_T100 NUMBER := 0;
    VL_INS_T100        NUMBER := 0;
    --
    VL_PROGR_D_T106      NUMBER := 0;
    VL_COUNT_XOUT_T106   NUMBER := 0;
    VL_COUNT_XOUT_T106_P NUMBER := 0;
    VL_INS_T106          NUMBER := 0;

    REC_XOUT_T100 XOUT_T100ORDHEAD%ROWTYPE := NULL;
    REC_XOUT_T106 XOUT_T106ORDROW%ROWTYPE := NULL;

    VL_STATUS   NUMBER := 0;
    VL_STEP     NUMBER := 0;
    --
    EX_EXIT EXCEPTION;
    --
  BEGIN

    VL_PROGR_D_T100 := PKG_UTILS.LOG_NEW_DETAIL(PI_PROGR_H,
                                                'ORDER HEAD',
                                                'EXPORT CREDIT ORDERS --> T100ORDHEAD',
                                                0,
                                                NULL);
    --
    VL_PROGR_D_T106 := PKG_UTILS.LOG_NEW_DETAIL(PI_PROGR_H,
                                                'ORDER ROWS',
                                                'EXPORT CREDIT ORDERS --> T106ORDROW',
                                                0,
                                                NULL);

    -- Clean old records in log table
    P_XOUT_CLEANUP_LOG(PI_PROGR_H,
                       VL_PROGR_D_T100,
                       'XOUT_T100ORDHEAD',
                       VL_STATUS);
    P_XOUT_CLEANUP_LOG(PI_PROGR_H,
                       VL_PROGR_D_T106,
                       'XOUT_T106ORDROW',
                       VL_STATUS);
    --
    -- Moves records from staging area to log staging area
    P_XOUT_MOVE_TO_LOG(PI_PROGR_H,
                       VL_PROGR_D_T100,
                       'XOUT_T100ORDHEAD',
                       VL_STATUS);
    IF (VL_STATUS <> 0) THEN
      RAISE EX_EXIT;
    END IF;
    P_XOUT_MOVE_TO_LOG(PI_PROGR_H,
                       VL_PROGR_D_T106,
                       'XOUT_T106ORDROW',
                       VL_STATUS);
    IF (VL_STATUS <> 0) THEN
      RAISE EX_EXIT;
    END IF;

    -- --------------------------------------------------------------
    -- Identifies  records to be Exported
    -- HERE YOU CAN CUSTOMIZE THE FILTER YOU NEED TO APPLY TO HEAD TABLE
    -- IN ORDER TO LOCK ONLY THE RECORDS THAT ARE REALLY TO BE EXPORTED

    -- --------------------------------------------------------------
    BEGIN
    
      VL_MESSAGE_D := 'T100ORDHEAD';
      UPDATE T100ORDHEAD T
         SET T.IDSESSIONLCK = PI_SESSION_ID,
             T.CODUSRLCK    = C_SYSUSR,
             T.DTELCK       = XSYSDATE
       WHERE t.DOCUMENTKEY = nvl(PI_DOCUMENTKEY, T.DOCUMENTKEY)
         and T.CODDIV = nvl(PI_CODDIV, T.coddiv)
         and (T.NUMORD, T.CODUSR, T.CODDIV) IN
             (SELECT Q.NUMORD, Q.CODUSR, Q.CODDIV
                FROM ZQEXP_T100CREDITORDER_SYG_C Q
               WHERE Q.DTEMOD >= NVL(PI_MASSIVE_EXP_DATE, Q.DTEMOD));
      VL_COUNT_XOUT_T100 := SQL%ROWCOUNT;
      COMMIT;
    
    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        VL_MESSAGE_H := 'Error while Locking: ' || VL_MESSAGE_D;
        RAISE EX_EXIT;
    END;

    -- --------------------------------------------------------------
    -- loops locked records in main table T100ORDHEAD to log them
    -- --------------------------------------------------------------
    FOR R_LOCKED IN CL_LOCKED_T100 LOOP
    
      VL_MESSAGE_H := 'Unable to Export ' || VL_MESSAGE_D || '.Numord=' ||
                      R_LOCKED.NUMORD || 'Codusr = ' || R_LOCKED.CODUSR ||
                      ' Record locked by user ' || R_LOCKED.CODUSRLCK ||
                      ' since ' ||
                      to_char(R_LOCKED.DTELCK, C_SM1_FORMAT_DATE);
    
      PKG_UTILS.LOG_NEW_DETAIL_ERROR(PI_PROGR_H,
                                     VL_PROGR_D_T100,
                                     SQLCODE,
                                     VL_MESSAGE_H);
    
    END LOOP;

    -- --------------------------------------------------------------
    -- loop in main table T100ORDHEAD
    -- --------------------------------------------------------------
    FOR RL_T100 IN CL_T100 LOOP
    
      -- pings to t035 every 1000 cicles--
      VL_STEP := VL_STEP + 1;
      IF (MOD(VL_STEP, 1000) = 0) THEN
        PKG_UTILS.user_ping(PI_SESSION_ID);
      END IF;
      --
      VL_STATUS    := 0;
      VL_MESSAGE_H := 'Order: ' || RL_T100.NUMORD || '/' || RL_T100.CODUSR;
      --
      BEGIN
      
        --- HEAD T100
        VL_MESSAGE_D := 'Insert XOUT_T100ORDHEAD ';
        -- Here you can customize field elaboration
        -- the default is the xout has the same value of sm1 table
        REC_XOUT_T100.NUMORD               := RL_T100.NUMORD;
        REC_XOUT_T100.CODUSR               := RL_T100.CODUSR;
        REC_XOUT_T100.CODEUSR              := RL_T100.CODEUSR;
        REC_XOUT_T100.CODSALESMAN          := RL_T100.CODSALESMAN;
        REC_XOUT_T100.CODTYPORD            := RL_T100.CODTYPORD;
        REC_XOUT_T100.CODSTATUS            := RL_T100.CODSTATUS;
        REC_XOUT_T100.CODDIV               := RL_T100.CODDIV;
        REC_XOUT_T100.CODBLCCAUSE          := RL_T100.CODBLCCAUSE;
        REC_XOUT_T100.DTEORD               := RL_T100.DTEORD;
        REC_XOUT_T100.DTEDELIV             := RL_T100.DTEDELIV;
        REC_XOUT_T100.CODTYPDELIV          := RL_T100.CODTYPDELIV;
        REC_XOUT_T100.DTEEVA               := RL_T100.DTEEVA;
        REC_XOUT_T100.CODPAYTRM            := RL_T100.CODPAYTRM;
        REC_XOUT_T100.CODPAYMOD            := RL_T100.CODPAYMOD;
        REC_XOUT_T100.CODCUSTDELIV         := RL_T100.CODCUSTDELIV;
        REC_XOUT_T100.CODVATMGMT           := RL_T100.CODVATMGMT;
        REC_XOUT_T100.CODCUSTINV           := RL_T100.CODCUSTINV;
        REC_XOUT_T100.CODLIST              := RL_T100.CODLIST;
        REC_XOUT_T100.CODCUR               := RL_T100.CODCUR;
        REC_XOUT_T100.NUMORDREF            := RL_T100.NUMORD;
        REC_XOUT_T100.NUMORDHOST           := RL_T100.NUMORDHOST;
        REC_XOUT_T100.NUMORDCUST           := TRIM(RL_T100.NUMORD) || TRIM(RL_T100.CODUSR);
        REC_XOUT_T100.DTEORDCUST           := RL_T100.DTEORDCUST;
        REC_XOUT_T100.CODASSORTMENT        := RL_T100.CODASSORTMENT;
        REC_XOUT_T100.CODCANVASS           := RL_T100.CODCANVASS;
        REC_XOUT_T100.CODMODSHIP           := RL_T100.CODMODSHIP;
        REC_XOUT_T100.CODMODDELIV          := RL_T100.CODMODDELIV;
        REC_XOUT_T100.CODAGREEMENT         := RL_T100.CODAGREEMENT;
        REC_XOUT_T100.OBJID                := RL_T100.OBJID;
        REC_XOUT_T100.DESAGREEMENT         := RL_T100.DESAGREEMENT;
        REC_XOUT_T100.CODUSRAUT            := RL_T100.CODUSRAUT;
        REC_XOUT_T100.CODAGREECLASS        := RL_T100.CODAGREECLASS;
        REC_XOUT_T100.DTEAUT               := RL_T100.DTEAUT;
        REC_XOUT_T100.CODTYPAUT            := RL_T100.CODTYPAUT;
        REC_XOUT_T100.DESAUT               := RL_T100.DESAUT;
        REC_XOUT_T100.DTETOSERVER          := RL_T100.DTETOSERVER;
        REC_XOUT_T100.DTETOHOST            := RL_T100.DTETOHOST;
        REC_XOUT_T100.GROSSAMOUNT          := RL_T100.GROSSAMOUNT;
        REC_XOUT_T100.NETAMOUNT            := RL_T100.NETAMOUNT;
        REC_XOUT_T100.TAXAMOUNT            := RL_T100.TAXAMOUNT;
        REC_XOUT_T100.VATAMOUNT            := RL_T100.VATAMOUNT;
        REC_XOUT_T100.INCREASEAMOUNT       := RL_T100.INCREASEAMOUNT;
        REC_XOUT_T100.DISCOUNTAMOUNT       := RL_T100.DISCOUNTAMOUNT;
        REC_XOUT_T100.GIFTAMOUNT           := RL_T100.GIFTAMOUNT;
        REC_XOUT_T100.DTECRE               := RL_T100.DTECRE;
        REC_XOUT_T100.DTEMOD               := RL_T100.DTEMOD;
        REC_XOUT_T100.DTELCK               := RL_T100.DTELCK;
        REC_XOUT_T100.CODUSRLCK            := RL_T100.CODUSRLCK;
        REC_XOUT_T100.CODUSRMOD            := RL_T100.CODUSRMOD;
        REC_XOUT_T100.FLGANN               := RL_T100.FLGANN;
        REC_XOUT_T100.PGMMODCL             := RL_T100.PGMMODCL;
        REC_XOUT_T100.PGMMODDB             := RL_T100.PGMMODDB;
        REC_XOUT_T100.CODABI               := RL_T100.CODABI;
        REC_XOUT_T100.CODCAB               := RL_T100.CODCAB;
        REC_XOUT_T100.DESBAN               := RL_T100.DESBAN;
        REC_XOUT_T100.DESBRA               := RL_T100.DESBRA;
        REC_XOUT_T100.DESADDR              := RL_T100.DESADDR;
        REC_XOUT_T100.DESLOC               := RL_T100.DESLOC;
        REC_XOUT_T100.DESPRV               := RL_T100.DESPRV;
        REC_XOUT_T100.QTYTOT               := RL_T100.QTYTOT;
        REC_XOUT_T100.CODPRV               := RL_T100.CODPRV;
        REC_XOUT_T100.UMQTYTOT             := RL_T100.UMQTYTOT;
        REC_XOUT_T100.CODACCOUNT           := RL_T100.CODACCOUNT;
        REC_XOUT_T100.FLGRETURN            := RL_T100.FLGRETURN;
        REC_XOUT_T100.FLGHOSTED            := RL_T100.FLGHOSTED;
        REC_XOUT_T100.FLGCONFIRMED         := RL_T100.FLGCONFIRMED;
        REC_XOUT_T100.IDSESSIONLCK         := RL_T100.IDSESSIONLCK;
        REC_XOUT_T100.CODWHS               := RL_T100.CODWHS;
        REC_XOUT_T100.CODSHIPPER           := RL_T100.CODSHIPPER;
        REC_XOUT_T100.CODAZCAPP            := RL_T100.CODAZCAPP;
        REC_XOUT_T100.CODAZCBEN            := RL_T100.CODAZCBEN;
        REC_XOUT_T100.DTEPRICE             := RL_T100.DTEPRICE;
        REC_XOUT_T100.CODTYPSALE           := RL_T100.CODTYPSALE;
        REC_XOUT_T100.FLGCHECKPROMO        := RL_T100.FLGCHECKPROMO;
        REC_XOUT_T100.CODAGREETYPE         := RL_T100.CODAGREETYPE;
        REC_XOUT_T100.CODSTATUSMAN         := RL_T100.CODSTATUSMAN;
        REC_XOUT_T100.DISCOUNTAMOUNTOUTINV := RL_T100.DISCOUNTAMOUNTOUTINV;
        REC_XOUT_T100.CODTYPORDCUST        := RL_T100.CODTYPORDCUST;
        REC_XOUT_T100.CODUSR3              := RL_T100.CODUSR3;
        REC_XOUT_T100.DTEDELIVTO           := RL_T100.DTEDELIVTO;
        REC_XOUT_T100.CODCIN               := RL_T100.CODCIN;
        REC_XOUT_T100.FLGUMORD2            := RL_T100.FLGUMORD2;
        REC_XOUT_T100.NETAMOUNTTEO         := RL_T100.NETAMOUNTTEO;
        REC_XOUT_T100.NETAMOUNTMIN         := RL_T100.NETAMOUNTMIN;
        REC_XOUT_T100.NETAMOUNTMAX         := RL_T100.NETAMOUNTMAX;
        REC_XOUT_T100.CODUSR4              := RL_T100.CODUSR4;
        REC_XOUT_T100.CODUSR2              := RL_T100.CODUSR2;
        REC_XOUT_T100.CODBUYEREDI          := RL_T100.CODBUYEREDI;
        REC_XOUT_T100.CODCUSTINVEDI        := RL_T100.CODCUSTINVEDI;
        REC_XOUT_T100.CODCUSTDELIVEDI      := RL_T100.CODCUSTDELIVEDI;
        REC_XOUT_T100.CODSELLEREDI         := RL_T100.CODSELLEREDI;
        REC_XOUT_T100.CODUSR6              := RL_T100.CODUSR6;
        REC_XOUT_T100.CODPDV               := RL_T100.CODPDV;
        REC_XOUT_T100.CODCUSTCONC          := RL_T100.CODCUSTCONC;
        REC_XOUT_T100.CODIBAN              := RL_T100.CODIBAN;
        REC_XOUT_T100.CODUSRCRE            := RL_T100.CODUSRCRE;
        REC_XOUT_T100.BACKAMOUNT           := RL_T100.BACKAMOUNT;
        REC_XOUT_T100.TOTPALLETS           := RL_T100.TOTPALLETS;
        REC_XOUT_T100.GROSSWEIGHT          := RL_T100.GROSSWEIGHT;
        REC_XOUT_T100.TOTMC                := RL_T100.TOTMC;
        REC_XOUT_T100.DTEPROPDELIV         := RL_T100.DTEPROPDELIV;
        REC_XOUT_T100.DOCUMENTKEY          := RL_T100.DOCUMENTKEY;
        REC_XOUT_T100.CODUSR5              := RL_T100.CODUSR5;
        REC_XOUT_T100.CODUSRMODREAL        := RL_T100.CODUSRMODREAL;
        REC_XOUT_T100.CODUSRCREREAL        := RL_T100.CODUSRCREREAL;
        REC_XOUT_T100.IDSURVEY             := RL_T100.IDSURVEY;
        REC_XOUT_T100.CODCUSTSALE          := RL_T100.CODCUSTSALE;
        REC_XOUT_T100.FLGPROCESSEDEDI      := RL_T100.FLGPROCESSEDEDI;
        REC_XOUT_T100.FLGEDI               := RL_T100.FLGEDI;
        REC_XOUT_T100.NUMESENZIONE         := RL_T100.NUMESENZIONE;
        REC_XOUT_T100.DTEDELIV2            := RL_T100.DTEDELIV2;
        REC_XOUT_T100.DTEDELIV3            := RL_T100.DTEDELIV3;
        REC_XOUT_T100.DTEDELIV4            := RL_T100.DTEDELIV4;
        REC_XOUT_T100.DTEDELIV5            := RL_T100.DTEDELIV5;
        --
        REC_XOUT_T100.SM1_DTEPROCESS := XSYSDATE;
        REC_XOUT_T100.SM1_CODPROCESS := PI_PROGR_H;
        -- Field is mandatory in XOUT_T100ORDHEAD_LOG
        REC_XOUT_T100.MOVED                := 0;
      
        INSERT INTO XOUT_T100ORDHEAD VALUES REC_XOUT_T100;
      
      EXCEPTION
        WHEN OTHERS THEN
          VL_STATUS    := -1;
          VL_MESSAGE_H := SUBSTR(VL_MESSAGE_H || ' ' || VL_MESSAGE_D || ' ' ||
                                 SQLERRM,
                                 1,
                                 2000);
        
          PKG_UTILS.LOG_NEW_DETAIL_ERROR(PI_PROGR_H,
                                         VL_PROGR_D_T100,
                                         SQLCODE,
                                         VL_MESSAGE_H);
      END;
    
      BEGIN
        -- ORDER ROWS T106
        --
        IF (VL_STATUS = 0) THEN
          FOR RL_T106 IN CL_T106(RL_T100.NUMORD, RL_T100.CODUSR) LOOP
          
            VL_MESSAGE_H := 'Ord Row ' || RL_T106.NUMORD || '/' ||
                            RL_T106.CODUSR || '/' || RL_T106.NUMROW;
          
            VL_MESSAGE_D                       := 'Insert  XOUT_T106ORDROW ';
            REC_XOUT_T106.CODUSR               := RL_T106.CODUSR;
            REC_XOUT_T106.NUMORD               := RL_T106.NUMORD;
            REC_XOUT_T106.NUMROW               := RL_T106.NUMROW;
            REC_XOUT_T106.CODART               := RL_T106.CODART;
            REC_XOUT_T106.CODDIV               := RL_T106.CODDIV;
            REC_XOUT_T106.UMORD                := RL_T106.UMORD;
            REC_XOUT_T106.DESART               := RL_T106.PRODUCTDES;
            REC_XOUT_T106.QTYORD               := RL_T106.QTYORD;
            REC_XOUT_T106.QTYBCKORD            := RL_T106.QTYBCKORD;
            REC_XOUT_T106.QTYANN               := RL_T106.QTYANN;
            REC_XOUT_T106.QTYDEL               := RL_T106.QTYDEL;
            REC_XOUT_T106.UMINV                := RL_T106.UMINV;
            REC_XOUT_T106.QTYINV               := RL_T106.QTYINV;
            REC_XOUT_T106.CODTYPROW            := RL_T106.CODTYPROW;
            REC_XOUT_T106.CODLIST              := RL_T106.CODLIST;
            REC_XOUT_T106.DTEDELIV             := RL_T106.DTEDELIV;
            REC_XOUT_T106.DTEPROPDELIV         := RL_T106.DTEPROPDELIV;
            REC_XOUT_T106.CODSTATUS            := RL_T106.CODSTATUS;
            REC_XOUT_T106.CODSHIPPER           := RL_T106.CODSHIPPER;
            REC_XOUT_T106.OBJID                := RL_T106.OBJID;
            REC_XOUT_T106.NUMDOCREF            := RL_T106.NUMDOCREF;
            REC_XOUT_T106.DTEDOCREF            := RL_T106.DTEDOCREF;
            REC_XOUT_T106.GROSSAMOUNT          := RL_T106.GROSSAMOUNT;
            REC_XOUT_T106.NUMINV               := RL_T106.NUMINV;
            REC_XOUT_T106.NETAMOUNT            := RL_T106.NETAMOUNT;
            REC_XOUT_T106.DTEINV               := RL_T106.DTEINV;
            REC_XOUT_T106.TAXAMOUNT            := RL_T106.TAXAMOUNT;
            REC_XOUT_T106.VATAMOUNT            := RL_T106.VATAMOUNT;
            REC_XOUT_T106.INCREASEAMOUNT       := RL_T106.INCREASEAMOUNT;
            REC_XOUT_T106.DISCOUNTAMOUNT       := RL_T106.DISCOUNTAMOUNT / RL_T106.QTYORD; 
            REC_XOUT_T106.GIFTAMOUNT           := RL_T106.GIFTAMOUNT;
            REC_XOUT_T106.ENDUSERPRICE         := RL_T106.ENDUSERPRICE;
            REC_XOUT_T106.CODAZCAPP            := RL_T106.CODAZCAPP;
            REC_XOUT_T106.FLGEFFBCKORD         := RL_T106.FLGEFFBCKORD;
            REC_XOUT_T106.CODBCKORDCAUSE       := RL_T106.CODBCKORDCAUSE;
            REC_XOUT_T106.GROSSARTAMOUNT       := RL_T106.GROSSARTAMOUNT;
            REC_XOUT_T106.NETARTAMOUNT         := RL_T106.NETARTAMOUNT;
            REC_XOUT_T106.CODSRC               := RL_T106.CODSRC;
            REC_XOUT_T106.CODSRCREF            := RL_T106.CODSRCREF;
            REC_XOUT_T106.CODBENCAUSE          := RL_T106.CODBENCAUSE;
            REC_XOUT_T106.CODBENSUBCAUSE       := RL_T106.CODBENSUBCAUSE;
            REC_XOUT_T106.BENNOTE              := RL_T106.BENNOTE;
            REC_XOUT_T106.AZCTOAPPLY           := RL_T106.AZCTOAPPLY;
            REC_XOUT_T106.CODOPERATION         := RL_T106.CODOPERATION;
            REC_XOUT_T106.DISCOUNTAMOUNTOUTINV := RL_T106.DISCOUNTAMOUNTOUTINV;
            REC_XOUT_T106.CODACCAPP            := RL_T106.CODACCAPP;
            REC_XOUT_T106.CODTYPROWCAUSE       := RL_T106.CODTYPROWCAUSE;
            REC_XOUT_T106.CODARTCUST           := RL_T106.CODARTCUST;
            REC_XOUT_T106.QTYRESO              := RL_T106.QTYRESO;
            REC_XOUT_T106.NUMORDRESO           := RL_T106.NUMORDRESO;
            REC_XOUT_T106.CODBLCCAUSE          := RL_T106.CODBLCCAUSE;
            REC_XOUT_T106.CODARTKITREF         := RL_T106.CODARTKITREF;
            REC_XOUT_T106.NUMROWKITREF         := RL_T106.NUMROWKITREF;
            REC_XOUT_T106.CODCAUSEKIT          := RL_T106.CODCAUSEKIT;
            REC_XOUT_T106.NETARTAMOUNTTEO      := RL_T106.NETARTAMOUNTTEO;
            REC_XOUT_T106.NETAMOUNTTEO         := RL_T106.NETAMOUNTTEO;
            REC_XOUT_T106.NETAMOUNTMIN         := RL_T106.NETAMOUNTMIN;
            REC_XOUT_T106.NETAMOUNTMAX         := RL_T106.NETAMOUNTMAX;
            REC_XOUT_T106.NETDIFF              := RL_T106.NETDIFF;
            REC_XOUT_T106.COD_ABBINAMENTO_KIT  := RL_T106.COD_ABBINAMENTO_KIT;
            REC_XOUT_T106.NUMROWORIG           := RL_T106.NUMROWORIG;
            REC_XOUT_T106.FLGFIRSTSON          := RL_T106.FLGFIRSTSON;
            REC_XOUT_T106.NETARTAMOUNTCUST     := RL_T106.NETARTAMOUNTCUST;
            REC_XOUT_T106.NETARTAMOUNTCUST2    := RL_T106.NETARTAMOUNTCUST2;
            REC_XOUT_T106.GROSSARTAMOUNTCUST   := RL_T106.GROSSARTAMOUNTCUST;
            REC_XOUT_T106.NETAMOUNTCUST        := RL_T106.NETAMOUNTCUST;
            REC_XOUT_T106.QTYORDEDI            := RL_T106.QTYORDEDI;
            REC_XOUT_T106.CODEAN               := RL_T106.CODEAN;
            REC_XOUT_T106.UMORDEDI             := RL_T106.UMORDEDI;
            REC_XOUT_T106.NUMROWREF            := RL_T106.NUMROWREF;
            REC_XOUT_T106.FLGOMGPROMO          := RL_T106.FLGOMGPROMO;
            REC_XOUT_T106.GROSSARTAMOUNTORD    := RL_T106.GROSSARTAMOUNTORD;
            REC_XOUT_T106.GROSSARTAMOUNTDELTA  := RL_T106.GROSSARTAMOUNTDELTA;
            REC_XOUT_T106.FLGOMGDISCLIST       := RL_T106.FLGOMGDISCLIST;
            REC_XOUT_T106.CODCNVPDA            := RL_T106.CODCNVPDA;
            REC_XOUT_T106.DTEEVA               := RL_T106.DTEEVA;
            REC_XOUT_T106.CODPAYTRM            := RL_T106.CODPAYTRM;
            REC_XOUT_T106.CODPAYMOD            := RL_T106.CODPAYMOD;
            REC_XOUT_T106.NUMORDHOST           := RL_T106.NUMORDHOST;
            REC_XOUT_T106.NUMROWHOST           := RL_T106.NUMROWHOST;
            REC_XOUT_T106.CODMODSHIP           := RL_T106.CODMODSHIP;
            REC_XOUT_T106.CODMODDELIV          := RL_T106.CODMODDELIV;
            REC_XOUT_T106.CODWHS               := RL_T106.CODWHS;
            REC_XOUT_T106.DTEPRICE             := RL_T106.DTEPRICE;
            REC_XOUT_T106.DTEDELIVTO           := RL_T106.DTEDELIVTO;
            REC_XOUT_T106.CODROWGROUP          := RL_T106.CODROWGROUP;
            REC_XOUT_T106.NETAMOUNTGIFT        := RL_T106.NETAMOUNTGIFT;
            REC_XOUT_T106.NETARTAMOUNTEDI      := RL_T106.NETARTAMOUNTEDI;
            REC_XOUT_T106.GROSSARTAMOUNTEDI    := RL_T106.GROSSARTAMOUNTEDI;
            --
            REC_XOUT_T106.SM1_DTEPROCESS := REC_XOUT_T100.SM1_DTEPROCESS;
            REC_XOUT_T106.SM1_CODPROCESS := REC_XOUT_T100.SM1_CODPROCESS;
          
            INSERT INTO XOUT_T106ORDROW VALUES REC_XOUT_T106;
          
            VL_INS_T106          := VL_INS_T106 + 1;
            VL_COUNT_XOUT_T106_P := CL_T106%ROWCOUNT;
            
          END LOOP;
          
          VL_COUNT_XOUT_T106   := VL_COUNT_XOUT_T106 + VL_COUNT_XOUT_T106_P;
          VL_COUNT_XOUT_T106_P := 0;
        END IF;
        --
      EXCEPTION
        WHEN OTHERS THEN
          VL_STATUS    := -1;
          VL_MESSAGE_H := SUBSTR(VL_MESSAGE_H || ' ' || VL_MESSAGE_D || ' ' ||
                                 SQLERRM,
                                 1,
                                 2000);
        
          PKG_UTILS.LOG_NEW_DETAIL_ERROR(PI_PROGR_H,
                                         VL_PROGR_D_T106,
                                         SQLCODE,
                                         VL_MESSAGE_H);
        
      END;
    
      -- if all records have been stored with success then it makes the commit
      -- set DTETOHOST
      IF VL_STATUS = 0 THEN
      
        VL_INS_T100 := VL_INS_T100 + 1;
        UPDATE T100ORDHEAD
           SET DTETOHOST    = REC_XOUT_T100.SM1_DTEPROCESS,
               DTELCK       = NULL,
               IDSESSIONLCK = NULL,
               CODUSRLCK    = NULL
         WHERE NUMORD = REC_XOUT_T100.NUMORD
           AND CODUSR = REC_XOUT_T100.CODUSR;
      
      ELSE
      
        UPDATE T100ORDHEAD
           SET DTELCK = NULL, IDSESSIONLCK = NULL, CODUSRLCK = NULL
         WHERE NUMORD = REC_XOUT_T100.NUMORD
           AND CODUSR = REC_XOUT_T100.CODUSR;
      
      END IF;
    
    END LOOP;
    COMMIT;
    -- Close Logs
    PKG_UTILS.LOG_END_DETAIL(PI_PROGR_H,
                             VL_PROGR_D_T106,
                             0,
                             VL_COUNT_XOUT_T106,
                             VL_INS_T106,
                             VL_COUNT_XOUT_T106 - VL_INS_T106);
    --
    PKG_UTILS.LOG_END_DETAIL(PI_PROGR_H,
                             VL_PROGR_D_T100,
                             0,
                             VL_COUNT_XOUT_T100,
                             VL_INS_T100,
                             VL_COUNT_XOUT_T100 - VL_INS_T100);

    PO_MSG    := VL_INS_T100 || ' Orders Exported';
    PO_STATUS := VL_INS_T100;

  EXCEPTION
    WHEN EX_EXIT THEN
    
      ROLLBACK;
      VL_MESSAGE_H := SUBSTR(VL_MESSAGE_H || SQLERRM, 1, 2000);
      PKG_UTILS.LOG_NEW_DETAIL_ERROR(PI_PROGR_H,
                                     VL_PROGR_D_T100,
                                     SQLCODE,
                                     VL_MESSAGE_H);
    
      PO_MSG    := VL_MESSAGE_H;
      PO_STATUS := -1;
    
    WHEN OTHERS THEN
    
      ROLLBACK;
      UPDATE T100ORDHEAD
         SET DTELCK = NULL, IDSESSIONLCK = NULL, CODUSRLCK = NULL
       WHERE CODUSRLCK = C_SYSUSR
         AND IDSESSIONLCK = PI_SESSION_ID;
      COMMIT;
    
      VL_MESSAGE_H := SUBSTR(VL_MESSAGE_H || SQLERRM, 1, 2000);
      PKG_UTILS.LOG_NEW_DETAIL_ERROR(PI_PROGR_H,
                                     VL_PROGR_D_T100,
                                     SQLCODE,
                                     VL_MESSAGE_H);
    
      PO_MSG    := VL_MESSAGE_H;
      PO_STATUS := VL_STATUS;
    
  END EXP_T10X_CREDIT_ORDERS_SYG;