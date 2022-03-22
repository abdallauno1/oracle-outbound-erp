DECLARE 

VL_OP         VARCHAR2(2000) := 'ORDERSKD_SYG';
VL_CODPROCESS NUMBER;
VL_MSG        VARCHAR2(2000);
VL_STATUS     NUMBER;

BEGIN
	PKG_XTEL_EXPORT_C.MAIN(VL_OP, NULL, NULL, VL_CODPROCESS, VL_MSG, VL_STATUS);
EXCEPTION
 WHEN OTHERS THEN
   VL_STATUS := -20500;
   VL_MSG := 'PKG_XTEL_EXPORT_C.MAIN: ' || VL_OP || ' ' || SQLERRM ;
   raise_application_error(VL_STATUS, VL_MSG);
END;
/
EXIT;