SPOOL &1;

SET SERVEROUTPUT ON;
SET HEADING OFF;
SET HEADSEP OFF;
SET SPACE 0;
SET PAGESIZE 0;
SET NEWPAGE 0;
SET MAXDATA 48000;
SET FEEDBACK OFF;
SET ECHO OFF;
SET TERMOUT OFF;
SET LINESIZE 2000;
SET TRIMSPOOL ON;
SET SQLBLANKLINES ON;

UPDATE XOUT_T106ORDROW T106
   SET ERP_STATUS = 0, ERP_DTEPROCESS = SYSDATE
 WHERE 1 = 1
   AND EXISTS (SELECT 1
                 FROM XOUT_T100ORDHEAD T100
                WHERE 1 = 1
                  AND T100.NUMORD = T106.NUMORD
                  AND T100.CODDIV = T106.CODDIV
              
                  AND T100.CODDIV = 'SYG'
                  AND CODTYPORD IN ('70', '80')
                  AND CODSTATUS IN ('11', '6')
              
                  AND T100.ERP_STATUS = 0
                  AND T100.ERP_DTEPROCESS IS NOT NULL);

SELECT 'CODUSR' || ',' || 'NUMORD' || ',' || 'NUMROW' || ',' || 'CODART' || ',' ||
       'CODDIV' || ',' || 'UMORD' || ',' || 'DESART' || ',' || 'QTYORD' || ',' ||
       'QTYBCKORD' || ',' || 'QTYANN' || ',' || 'QTYDEL' || ',' || 'UMINV' || ',' ||
       'QTYINV' || ',' || 'CODTYPROW' || ',' || 'CODLIST' || ',' ||
       'DTEDELIV' || ',' || 'DTEPROPDELIV' || ',' || 'CODSTATUS' || ',' ||
       'CODSHIPPER' || ',' || 'NUMDOCREF' || ',' || 'DTEDOCREF' || ',' ||
       'GROSSAMOUNT' || ',' || 'NUMINV' || ',' || 'NETAMOUNT' || ',' ||
       'DTEINV' || ',' || 'TAXAMOUNT' || ',' || 'VATAMOUNT' || ',' ||
       'INCREASEAMOUNT' || ',' || 'DISCOUNTAMOUNT' || ',' || 'GIFTAMOUNT' || ',' ||
       'ENDUSERPRICE' || ',' || 'CODAZCAPP' || ',' || 'FLGEFFBCKORD' || ',' ||
       'CODBCKORDCAUSE' || ',' || 'GROSSARTAMOUNT' || ',' || 'NETARTAMOUNT' || ',' ||
       'CODSRC' || ',' || 'CODSRCREF' || ',' || 'CODBENCAUSE' || ',' ||
       'CODBENSUBCAUSE' || ',' || 'BENNOTE' || ',' || 'AZCTOAPPLY' || ',' ||
       'CODOPERATION' || ',' || 'DISCOUNTAMOUNTOUTINV' || ',' ||
       'CODACCAPP' || ',' || 'CODTYPROWCAUSE' || ',' || 'CODARTCUST' || ',' ||
       'QTYRESO' || ',' || 'NUMORDRESO' || ',' || 'CODBLCCAUSE' || ',' ||
       'CODARTKITREF' || ',' || 'NUMROWKITREF' || ',' || 'CODCAUSEKIT' || ',' ||
       'NETARTAMOUNTTEO' || ',' || 'NETAMOUNTTEO' || ',' || 'NETAMOUNTMIN' || ',' ||
       'NETAMOUNTMAX' || ',' || 'NETDIFF' || ',' || 'COD_ABBINAMENTO_KIT' || ',' ||
       'NUMROWORIG' || ',' || 'FLGFIRSTSON' || ',' || 'NETARTAMOUNTCUST' || ',' ||
       'NETARTAMOUNTCUST2' || ',' || 'GROSSARTAMOUNTCUST' || ',' ||
       'NETAMOUNTCUST' || ',' || 'QTYORDEDI' || ',' || 'CODEAN' || ',' ||
       'UMORDEDI' || ',' || 'NUMROWREF' || ',' || 'FLGOMGPROMO' || ',' ||
       'GROSSARTAMOUNTORD' || ',' || 'GROSSARTAMOUNTDELTA' || ',' ||
       'FLGOMGDISCLIST' || ',' || 'CODCNVPDA' || ',' || 'DTEEVA' || ',' ||
       'CODPAYTRM' || ',' || 'CODPAYMOD' || ',' || 'NUMORDHOST' || ',' ||
       'NUMROWHOST' || ',' || 'CODMODSHIP' || ',' || 'CODMODDELIV' || ',' ||
       'CODWHS' || ',' || 'CODWHSDELIV' || ',' || 'DTEPRICE' || ',' ||
       'DTEDELIVTO' || ',' || 'CODROWGROUP' || ',' || 'NETAMOUNTGIFT' || ',' ||
       'NETARTAMOUNTEDI' || ',' || 'GROSSARTAMOUNTEDI' || ',' ||
       'QTYORDORIG' || ',' || 'QTYALLOCATED' || ',' || 'RETURNAMOUNT' || ',' ||
       'NETARTAMOUNTUMORD' || ',' || 'CODQTYMODCAUSE' || ',' ||
       'GROSSARTAMOUNTUMORD' || ',' || 'Z_DTEXPIRE' || ',' || 'SM1_DTECRE' || ',' ||
       'SM1_CODPROCESS' || ',' || 'SM1_STATUS' || ',' || 'SM1_DTEPROCESS' || ',' ||
       'ERP_DOCREFERENCE'
  FROM dual;

SELECT T106.CODUSR || ',' || T106.NUMORD || ',' || T106.NUMROW || ',' ||
       GET_PRODUCT_CODE(T106.CODDIV, T106.CODART)  || ',' ||
       T106.CODDIV || ',' || T106.UMORD || ',' ||
       T106.DESART || ',' || T106.QTYORD || ',' || T106.QTYBCKORD || ',' ||
       T106.QTYANN || ',' || T106.QTYDEL || ',' || T106.UMINV || ',' ||
       T106.QTYINV || ',' || T106.CODTYPROW || ',' || T106.CODLIST || ',' ||
       TO_CHAR(TRUNC(T106.DTEDELIV), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(T106.DTEPROPDELIV), 'YYYYMMDD') || ',' ||
       T106.CODSTATUS || ',' || T106.CODSHIPPER || ',' || T106.NUMDOCREF || ',' ||
       TO_CHAR(TRUNC(T106.DTEDOCREF), 'YYYYMMDD') || ',' || T106.GROSSAMOUNT || ',' || T106.NUMINV || ',' ||
       T106.NETAMOUNT || ',' || TO_CHAR(TRUNC(T106.DTEINV), 'YYYYMMDD') || ',' ||
       T106.TAXAMOUNT || ',' || T106.VATAMOUNT || ',' ||
       T106.INCREASEAMOUNT || ',' || T106.DISCOUNTAMOUNT || ',' ||
       T106.GIFTAMOUNT || ',' || T106.ENDUSERPRICE || ',' || T106.CODAZCAPP || ',' ||
       T106.FLGEFFBCKORD || ',' || T106.CODBCKORDCAUSE || ',' ||
       T106.GROSSARTAMOUNT || ',' || T106.NETARTAMOUNT || ',' ||
       T106.CODSRC || ',' || T106.CODSRCREF || ',' || T106.CODBENCAUSE || ',' ||
       T106.CODBENSUBCAUSE || ',' || T106.BENNOTE || ',' || T106.AZCTOAPPLY || ',' ||
       T106.CODOPERATION || ',' || T106.DISCOUNTAMOUNTOUTINV || ',' ||
       T106.CODACCAPP || ',' || T106.CODTYPROWCAUSE || ',' ||
       T106.CODARTCUST || ',' || T106.QTYRESO || ',' || T106.NUMORDRESO || ',' ||
       T106.CODBLCCAUSE || ',' || T106.CODARTKITREF || ',' ||
       T106.NUMROWKITREF || ',' || T106.CODCAUSEKIT || ',' ||
       T106.NETARTAMOUNTTEO || ',' || T106.NETAMOUNTTEO || ',' ||
       T106.NETAMOUNTMIN || ',' || T106.NETAMOUNTMAX || ',' || T106.NETDIFF || ',' ||
       T106.COD_ABBINAMENTO_KIT || ',' || T106.NUMROWORIG || ',' ||
       T106.FLGFIRSTSON || ',' || T106.NETARTAMOUNTCUST || ',' ||
       T106.NETARTAMOUNTCUST2 || ',' || T106.GROSSARTAMOUNTCUST || ',' ||
       T106.NETAMOUNTCUST || ',' || T106.QTYORDEDI || ',' || T106.CODEAN || ',' ||
       T106.UMORDEDI || ',' || T106.NUMROWREF || ',' || T106.FLGOMGPROMO || ',' ||
       T106.GROSSARTAMOUNTORD || ',' || T106.GROSSARTAMOUNTDELTA || ',' ||
       T106.FLGOMGDISCLIST || ',' || T106.CODCNVPDA || ',' ||
       TO_CHAR(TRUNC(T106.DTEEVA), 'YYYYMMDD') || ',' || T106.CODPAYTRM || ',' ||
       T106.CODPAYMOD || ',' || T106.NUMORDHOST || ',' || T106.NUMROWHOST || ',' ||
       T106.CODMODSHIP || ',' || T106.CODMODDELIV || ',' || T106.CODWHS || ',' ||
       T100.CODWHSDELIV || ',' || TO_CHAR(TRUNC(T106.DTEPRICE), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(T106.DTEDELIVTO), 'YYYYMMDD') || ',' ||
       T106.CODROWGROUP || ',' || T106.NETAMOUNTGIFT || ',' ||
       T106.NETARTAMOUNTEDI || ',' || T106.GROSSARTAMOUNTEDI || ',' ||
       T106.QTYORDORIG || ',' || T106.QTYALLOCATED || ',' ||
       T106.RETURNAMOUNT || ',' || T106.NETARTAMOUNTUMORD || ',' ||
       T106.CODQTYMODCAUSE || ',' || T106.GROSSARTAMOUNTUMORD || ',' ||
       TO_CHAR(TRUNC(T106.Z_DTEXPIRE), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(T100.DTECRE), 'YYYYMMDD') || ',' ||
       T106.SM1_CODPROCESS || ',' || T100.SM1_STATUS || ',' ||
       TO_CHAR(TRUNC(T106.SM1_DTEPROCESS), 'YYYYMMDD') || ',' ||
       T100.ERP_DOCREFERENCE
  FROM XOUT_T106ORDROW T106

  JOIN XOUT_T100ORDHEAD T100
    ON T100.NUMORD = T106.NUMORD
   AND T100.CODDIV = T106.CODDIV

 WHERE 1 = 1
   AND T100.CODDIV = 'SYG'
   AND T100.CODTYPORD IN ('70', '80')
   AND T100.CODSTATUS IN ('11', '6')
      
   AND T106.ERP_STATUS = 0
   AND T106.ERP_DTEPROCESS IS NOT NULL

 ORDER BY T106.NUMORD,
          T106.NUMROW;

SET ECHO OFF;
SPOOL off;

EXIT;
/