
  CREATE OR REPLACE FORCE VIEW "DCODEQA70"."ZQEXP_T100_PRICEDELIVERY_SYG_C" ("NUMORD", "CODUSR", "CODEUSR", "CODTYPORD", "CODSTATUS", "CODDIV", "CODBLCCAUSE", "DTEORD", "DTEDELIV", "CODTYPDELIV", "DTEEVA", "CODPAYTRM", "CODPAYMOD", "CODCUSTDELIV", "CODVATMGMT", "CODCUSTINV", "CODLIST", "CODCUR", "NUMORDREF", "NUMORDHOST", "NUMORDCUST", "DTEORDCUST", "CODASSORTMENT", "CODCANVASS", "CODMODSHIP", "CODMODDELIV", "CODAGREEMENT", "OBJID", "DESAGREEMENT", "CODUSRAUT", "CODAGREECLASS", "DTEAUT", "CODTYPAUT", "DESAUT", "DTETOSERVER", "DTETOHOST", "GROSSAMOUNT", "NETAMOUNT", "TAXAMOUNT", "VATAMOUNT", "INCREASEAMOUNT", "DISCOUNTAMOUNT", "GIFTAMOUNT", "DTECRE", "DTEMOD", "DTELCK", "CODUSRLCK", "CODUSRMOD", "FLGANN", "PGMMODCL", "PGMMODDB", "CODABI", "CODCAB", "DESBAN", "DESBRA", "DESADDR", "DESLOC", "DESPRV", "QTYTOT", "CODPRV", "UMQTYTOT", "CODACCOUNT", "FLGRETURN", "FLGHOSTED", "FLGCONFIRMED", "IDSESSIONLCK", "CODWHS", "CODSHIPPER", "CODAZCAPP", "CODAZCBEN", "DTEPRICE", "CODTYPSALE", "FLGCHECKPROMO", "CODAGREETYPE", "CODSTATUSMAN", "DISCOUNTAMOUNTOUTINV", "CODTYPORDCUST", "CODUSR3", "DTEDELIVTO", "CODCIN", "FLGUMORD2", "NETAMOUNTTEO", "NETAMOUNTMIN", "NETAMOUNTMAX", "CODUSR4", "CODUSR2", "CODBUYEREDI", "CODCUSTINVEDI", "CODCUSTDELIVEDI", "CODSELLEREDI", "CODUSR6", "CODPDV", "CODCUSTCONC", "CODIBAN", "CODUSRCRE", "BACKAMOUNT", "TOTPALLETS", "GROSSWEIGHT", "TOTMC", "DTEPROPDELIV", "DOCUMENTKEY", "CODUSR5", "CODUSRMODREAL", "CODUSRCREREAL", "IDSURVEY", "CODCUSTSALE", "FLGPROCESSEDEDI", "FLGEDI", "NUMESENZIONE", "DTEDELIV2", "DTEDELIV3", "DTEDELIV4", "DTEDELIV5", "IDROUTE", "NUMDOC", "DTECLOSE", "RETURNAMOUNT", "GPSVALLATITUDE", "GPSVALLONGITUDE") AS 
  SELECT t.NUMORD,
       t.CODUSR,
       t.CODEUSR,
       t.CODTYPORD,
       t.CODSTATUS,
       t.CODDIV,
       t.CODBLCCAUSE,
       t.DTEORD,
       t.DTEDELIV,
       t.CODTYPDELIV,
       t.DTEEVA,
       t.CODPAYTRM,
       t.CODPAYMOD,
       t.CODCUSTDELIV,
       t.CODVATMGMT,
       t.CODCUSTINV,
       t.CODLIST,
       t.CODCUR,
       t.numord || t.codusr as NUMORDREF,
       t.NUMORDHOST,
       t.NUMORDCUST,
       t.DTEORDCUST,
       t.CODASSORTMENT,
       t.CODCANVASS,
       t.CODMODSHIP,
       t.CODMODDELIV,
       t.CODAGREEMENT,
       t.OBJID,
       t.DESAGREEMENT,
       t.CODUSRAUT,
       t.CODAGREECLASS,
       t.DTEAUT,
       t.CODTYPAUT,
       t.DESAUT,
       t.DTETOSERVER,
       t.DTETOHOST,
       t.GROSSAMOUNT,
       t.NETAMOUNT,
       t.TAXAMOUNT,
       t.VATAMOUNT,
       t.INCREASEAMOUNT,
       t.DISCOUNTAMOUNT,
       t.GIFTAMOUNT,
       t.DTECRE,
       t.DTEMOD,
       t.DTELCK,
       t.CODUSRLCK,
       t.CODUSRMOD,
       t.FLGANN,
       t.PGMMODCL,
       t.PGMMODDB,
       t.CODABI,
       t.CODCAB,
       t.DESBAN,
       t.DESBRA,
       t.DESADDR,
       t.DESLOC,
       t.DESPRV,
       t.QTYTOT,
       t.CODPRV,
       t.UMQTYTOT,
       t.CODACCOUNT,
       t.FLGRETURN,
       t.FLGHOSTED,
       t.FLGCONFIRMED,
       t.IDSESSIONLCK,
       t.CODWHS,
       t.CODSHIPPER,
       t.CODAZCAPP,
       CODAZCBEN,
       t.DTEPRICE,
       t.CODTYPSALE,
       t.FLGCHECKPROMO,
       t.CODAGREETYPE,
       t.CODSTATUSMAN,
       t.DISCOUNTAMOUNTOUTINV,
       t.CODTYPORDCUST,
       t.CODUSR3,
       t.DTEDELIVTO,
       t.CODCIN,
       t.FLGUMORD2,
       t.NETAMOUNTTEO,
       t.NETAMOUNTMIN,
       t.NETAMOUNTMAX,
       t.CODUSR4,
       t.CODUSR2,
       t.CODBUYEREDI,
       CUST.CODCATDIV1 AS CODCUSTINVEDI,
       t.CODCUSTDELIVEDI,
       t.CODSELLEREDI,
       t.CODUSR6,
       t.CODPDV,
       t.CODCUSTCONC,
       t.CODIBAN,
       t.CODUSRCRE,
       t.BACKAMOUNT,
       t.TOTPALLETS,
       t.GROSSWEIGHT,
       t.TOTMC,
       t.DTEPROPDELIV,
       t.DOCUMENTKEY,
       t.CODUSR5,
       t.CODUSRMODREAL,
       t.CODUSRCREREAL,
       t.IDSURVEY,
       t.CODCUSTSALE,
       t.FLGPROCESSEDEDI,
       t.FLGEDI,
       t.NUMESENZIONE,
       t.DTEDELIV2,
       t.DTEDELIV3,
       t.DTEDELIV4,
       t.DTEDELIV5,
       t.IDROUTE,
       t.NUMDOC,
       t.DTECLOSE,
       t.RETURNAMOUNT,
       t.GPSVALLATITUDE,
       t.GPSVALLONGITUDE
  FROM T100ORDHEAD t

 INNER JOIN T041PARTYDIV CUST
    ON t.CODCUSTINV = CUST.CODPARTY
   AND t.CODDIV = CUST.CODDIV

 WHERE NVL(t.DTETOHOST, to_Date('30121899', 'DDMMYYYY')) =
       TO_DATE('30121899', 'DDMMYYYY')
   AND (t.DTELCK IS NULL OR t.DTELCK < SYSDATE - 1)
   AND t.CODSTATUS = 16
   AND t.CODDIV = 'SYG'
   AND t.CODTYPORD = '0'
 ORDER BY DTEORD DESC
;