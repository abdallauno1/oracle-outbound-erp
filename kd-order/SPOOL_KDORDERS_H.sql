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

UPDATE XOUT_T100ORDHEAD
   SET ERP_STATUS = 0, ERP_DTEPROCESS = SYSDATE
 WHERE 1 = 1
   AND CODDIV = 'SYG'
   AND CODTYPORD IN ('0', '1')
   AND CODSTATUS = '1';

SELECT 'NUMORD' || ',' || 'CODUSR' || ',' || 'CODEUSR' || ',' ||
       'CODTYPORD' || ',' || 'CODSTATUS' || ',' || 'CODDIV' || ',' ||
       'CODBLCCAUSE' || ',' || 'DTEORD' || ',' || 'DTEDELIV' || ',' ||
       'CODTYPDELIV' || ',' || 'DTEEVA' || ',' || 'CODPAYTRM' || ',' ||
       'CODPAYMOD' || ',' || 'CODCUSTDELIV' || ',' || 'CODVATMGMT' || ',' ||
       'CODCUSTINV' || ',' || 'CODLIST' || ',' || 'CODCUR' || ',' ||
       'NUMORDREF' || ',' || 'NUMORDHOST' || ',' || 'NUMORDCUST' || ',' ||
       'DTEORDCUST' || ',' || 'CODASSORTMENT' || ',' || 'CODCANVASS' || ',' ||
       'CODMODSHIP' || ',' || 'CODMODDELIV' || ',' || 'CODAGREEMENT' || ',' ||
       'DESAGREEMENT' || ',' || 'CODUSRAUT' || ',' || 'CODAGREECLASS' || ',' ||
       'DTEAUT' || ',' || 'CODTYPAUT' || ',' || 'DESAUT' || ',' ||
       'GROSSAMOUNT' || ',' || 'NETAMOUNT' || ',' || 'TAXAMOUNT' || ',' ||
       'VATAMOUNT' || ',' || 'INCREASEAMOUNT' || ',' || 'DISCOUNTAMOUNT' || ',' ||
       'GIFTAMOUNT' || ',' || 'FLGANN' || ',' || 'CODABI' || ',' ||
       'CODCAB' || ',' || 'DESBAN' || ',' || 'DESBRA' || ',' || 'DESADDR' || ',' ||
       'DESLOC' || ',' || 'DESPRV' || ',' || 'QTYTOT' || ',' || 'CODPRV' || ',' ||
       'UMQTYTOT' || ',' || 'CODACCOUNT' || ',' || 'FLGRETURN' || ',' ||
       'FLGHOSTED' || ',' || 'FLGCONFIRMED' || ',' || 'CODWHS' || ',' ||
       'CODWHSDELIV' || ',' || 'CODSHIPPER' || ',' || 'CODAZCAPP' || ',' ||
       'CODAZCBEN' || ',' || 'DTEPRICE' || ',' || 'CODTYPSALE' || ',' ||
       'FLGCHECKPROMO' || ',' || 'CODAGREETYPE' || ',' || 'CODSTATUSMAN' || ',' ||
       'DISCOUNTAMOUNTOUTINV' || ',' || 'CODTYPORDCUST' || ',' || 'CODUSR3' || ',' ||
       'DTEDELIVTO' || ',' || 'CODCIN' || ',' || 'FLGUMORD2' || ',' ||
       'NETAMOUNTTEO' || ',' || 'NETAMOUNTMIN' || ',' || 'NETAMOUNTMAX' || ',' ||
       'CODUSR4' || ',' || 'CODUSR2' || ',' || 'CODBUYEREDI' || ',' ||
       'CODCUSTINVEDI' || ',' || 'CODCUSTDELIVEDI' || ',' || 'CODSELLEREDI' || ',' ||
       'CODUSR6' || ',' || 'CODPDV' || ',' || 'CODCUSTCONC' || ',' ||
       'CODIBAN' || ',' || 'BACKAMOUNT' || ',' || 'TOTPALLETS' || ',' ||
       'GROSSWEIGHT' || ',' || 'TOTMC' || ',' || 'DTEPROPDELIV' || ',' ||
       'CODUSR5' || ',' || 'IDSURVEY' || ',' || 'CODCUSTSALE' || ',' ||
       'FLGPROCESSEDEDI' || ',' || 'FLGEDI' || ',' || 'NUMESENZIONE' || ',' ||
       'DTEDELIV2' || ',' || 'DTEDELIV3' || ',' || 'DTEDELIV4' || ',' ||
       'DTEDELIV5' || ',' || 'IDROUTE' || ',' || 'NUMDOC' || ',' ||
       'DTECLOSE' || ',' || 'RETURNAMOUNT' || ',' || 'GPSVALLATITUDE' || ',' ||
       'GPSVALLONGITUDE' || ',' || 'DTENEW' || ',' || 'CALCULATEDSPENTTIME' || ',' ||
       'CODPRINCIPALUSR' || ',' || 'Z_FLGPICKINGDONE' || ',' ||
       'Z_FLGCREATEBACKORDER' || ',' || 'Z_NUMFIRSTORDER' || ',' ||
       'SM1_DTECRE' || ',' || 'SM1_CODPROCESS' || ',' || 'SM1_STATUS' || ',' ||
       'SM1_DTEPROCESS' || ',' || 'ERP_DOCREFERENCE' || ',' || 'IDDAY' || ',' ||
       'CODLOCATION' || ',' || 'FLGPROCESSEDASSET' || ',' || 'CODADDR' || ',' || 'Z_FLG_KD_ORD'
  FROM DUAL;

SELECT NUMORD || ',' || CODUSR || ',' || CODEUSR || ',' || CODTYPORD || ',' ||
       CODSTATUS || ',' || CODDIV || ',' || CODBLCCAUSE || ',' ||
       TO_CHAR(TRUNC(DTEORD), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(DTEDELIV), 'YYYYMMDD') || ',' || CODTYPDELIV || ',' ||
       TO_CHAR(TRUNC(DTEEVA), 'YYYYMMDD') || ',' || CODPAYTRM || ',' ||
       CODPAYMOD || ',' || CODCUSTDELIV || ',' || CODVATMGMT || ',' ||
       CODCUSTINV || ',' || CODLIST || ',' || CODCUR || ',' || NUMORDREF || ',' ||
       NUMORDHOST || ',' || NUMORDCUST || ',' || TO_CHAR(TRUNC(DTEORDCUST), 'YYYYMMDD') || ',' ||
       CODASSORTMENT || ',' || CODCANVASS || ',' || CODMODSHIP || ',' ||
       CODMODDELIV || ',' || CODAGREEMENT || ',' || DESAGREEMENT || ',' ||
       CODUSRAUT || ',' || CODAGREECLASS || ',' ||
       TO_CHAR(TRUNC(DTEAUT), 'YYYYMMDD') || ',' || CODTYPAUT || ',' ||
       DESAUT || ',' || GROSSAMOUNT || ',' || NETAMOUNT || ',' || TAXAMOUNT || ',' ||
       VATAMOUNT || ',' || INCREASEAMOUNT || ',' || DISCOUNTAMOUNT || ',' ||
       GIFTAMOUNT || ',' || FLGANN || ',' || CODABI || ',' || CODCAB || ',' ||
       DESBAN || ',' || DESBRA || ',' || DESADDR || ',' || DESLOC || ',' ||
       DESPRV || ',' || QTYTOT || ',' || CODPRV || ',' || UMQTYTOT || ',' ||
       CODACCOUNT || ',' || FLGRETURN || ',' || FLGHOSTED || ',' ||
       FLGCONFIRMED || ',' || CODWHS || ',' || CODWHSDELIV || ',' ||
       CODSHIPPER || ',' || CODAZCAPP || ',' || CODAZCBEN || ',' ||
       TO_CHAR(TRUNC(DTEPRICE), 'YYYYMMDD') || ',' || CODTYPSALE || ',' ||
       FLGCHECKPROMO || ',' || CODAGREETYPE || ',' || CODSTATUSMAN || ',' ||
       DISCOUNTAMOUNTOUTINV || ',' || CODTYPORDCUST || ',' || CODUSR3 || ',' ||
       TO_CHAR(TRUNC(DTEDELIVTO), 'YYYYMMDD') || ',' || CODCIN || ',' ||
       FLGUMORD2 || ',' || NETAMOUNTTEO || ',' || NETAMOUNTMIN || ',' ||
       NETAMOUNTMAX || ',' || CODUSR4 || ',' || CODUSR2 || ',' ||
       CODBUYEREDI || ',' || CODCUSTINVEDI || ',' || CODCUSTDELIVEDI || ',' ||
       CODSELLEREDI || ',' || CODUSR6 || ',' || CODPDV || ',' ||
       CODCUSTCONC || ',' || CODIBAN || ',' || BACKAMOUNT || ',' ||
       TOTPALLETS || ',' || GROSSWEIGHT || ',' || TOTMC || ',' ||
       TO_CHAR(TRUNC(DTEPROPDELIV), 'YYYYMMDD') || ',' || CODUSR5 || ',' ||
       IDSURVEY || ',' || CODCUSTSALE || ',' || FLGPROCESSEDEDI || ',' ||
       FLGEDI || ',' || NUMESENZIONE || ',' ||
       TO_CHAR(TRUNC(DTEDELIV2), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(DTEDELIV3), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(DTEDELIV4), 'YYYYMMDD') || ',' ||
       TO_CHAR(TRUNC(DTEDELIV5), 'YYYYMMDD') || ',' || IDROUTE || ',' ||
       NUMDOC || ',' || TO_CHAR(TRUNC(DTECLOSE), 'YYYYMMDD') || ',' ||
       RETURNAMOUNT || ',' || GPSVALLATITUDE || ',' || GPSVALLONGITUDE || ',' ||
       TO_CHAR(TRUNC(DTENEW), 'YYYYMMDD') || ',' || CALCULATEDSPENTTIME || ',' ||
       CODPRINCIPALUSR || ',' || Z_FLGPICKINGDONE || ',' ||
       Z_FLGCREATEBACKORDER || ',' || Z_NUMFIRSTORDER || ',' ||
       TO_CHAR(TRUNC(DTECRE), 'YYYYMMDD') || ',' || SM1_CODPROCESS || ',' ||
       SM1_STATUS || ',' || TO_CHAR(TRUNC(SM1_DTEPROCESS), 'YYYYMMDD') || ',' || ERP_DOCREFERENCE || ',' ||
       IDDAY || ',' || CODLOCATION || ',' || FLGPROCESSEDASSET || ',' ||
       CODADDR || ',' || Z_FLG_KD_ORD
  FROM XOUT_T100ORDHEAD
 WHERE 1 = 1
   AND CODDIV = 'SYG'
   AND CODTYPORD IN ('0', '1')
   AND CODSTATUS = '1'
   AND ERP_STATUS = 0
   and ERP_DTEPROCESS IS NOT NULL;

SET ECHO OFF;
SPOOL off;

EXIT;
/