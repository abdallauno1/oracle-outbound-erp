create or replace PACKAGE "PKG_XTEL_EXPORT_C" AS
  --
  -- P R O C E D U R E
  -- 2014 19 12; 014; MBandiera; tfs 33433; ORDERS; fix on division retrieve
  -- 2014 10 17; 013: Mbandiera; tfs 32462; ORDERS; Exportable orders read in external view QEXP_T100ORDHEAD
  --                                                Added division as input parameter (used PI_CODE_CHAR_A)
  -- 2014 03 10; 012: Mbandiera; tfs 29729; main; added Massive export and one documentkey export modalities
  -- 2014 01 27; 011: Mbandiera; EXPORT PROMO added tables TA5022; TA5012; TA5014; TA5026
  -- 2013 10 29; 010: Mbandiera; TFS 27929: XOUT_QUESTIONNAIR field DESANSWER was populated for multiple choice questions only

  -- 2013 03 19; 009: Mbandiera;  added check on T035LOGGEDUSER when record seems to be locked
  /*============================================================================*/
  /*         Main Procedure  for Data Extractin                                 */
  /*============================================================================*/
  PROCEDURE MAIN(PI_OPERATION          IN VARCHAR2,
                   PI_DOCUMENTKEY      IN VARCHAR2,
                   PI_MASSIVE_EXP_DATE IN DATE,
                   --
                   PO_CODPROCESS        OUT NUMBER,
                   PO_MSG               OUT VARCHAR2,
                   PO_STATUS            OUT NUMBER,
                   PI_CODE_CHAR_A       IN VARCHAR2 DEFAULT NULL,
                   PI_CODE_CHAR_B       IN VARCHAR2 DEFAULT NULL,
                   PI_CODE_NUM_A        IN NUMBER DEFAULT NULL,
                   PI_CODE_NUM_B        IN NUMBER DEFAULT NULL,
                   PI_DATE_A            IN DATE DEFAULT NULL,
                   PI_DATE_B            IN DATE DEFAULT NULL);


END PKG_XTEL_EXPORT_C;
