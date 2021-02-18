/*
CAIQUE BISPO FERREIRA - 301093125

Assignment 5-10: Returning a Record
Create a procedure named DDPROJ_SP that retrieves project information for a specific project
based on a project ID. The procedure should have two parameters: one to accept a project ID
value and another to return all data for the specified project. Use a record variable to have the
procedure return all database column values for the selected project. Test the procedure with an
anonymous block.
*/
CREATE OR REPLACE 
PROCEDURE DDPROJ_SP
(
    vID_PROJ IN DD_PROJECT.IDPROJ%TYPE,
    R_DD_PROJECT OUT DD_PROJECT%ROWTYPE  
)
IS
BEGIN
    SELECT * 
    INTO R_DD_PROJECT
    FROM DD_PROJECT
    WHERE IDPROJ = vID_PROJ;
END;

DECLARE 
    R_DD_PROJECT DD_PROJECT%ROWTYPE;
BEGIN
    DDPROJ_SP(500,R_DD_PROJECT);
    DBMS_OUTPUT.PUT_LINE('IDPROJ: '||R_DD_PROJECT.IDPROJ||',PROJNAME: '||R_DD_PROJECT.PROJNAME||', PROJSTARTDATE: '||R_DD_PROJECT.PROJSTARTDATE||', PROJENDDATE:'||R_DD_PROJECT.PROJENDDATE);
END;

/*
Assignment 5-11: Creating a Procedure
Create a procedure named DDPAY_SP that identifies whether a donor currently has an active pledge
with monthly payments. A donor ID is the input to the procedure. Using the donor ID, the procedure
needs to determine whether the donor has any currently active pledges based on the status field
and is on a monthly payment plan. If so, the procedure is to return the Boolean value TRUE.
Otherwise, the value FALSE should be returned. Test the procedure with an anonymous block.
*/

CREATE OR REPLACE 
PROCEDURE DDPAY_SP
(
    vIDDONOR IN DD_PLEDGE.IDDONOR%TYPE,
    vRETURN OUT BOOLEAN 
)
IS
    v_NUMBER_OF_PLEDGES NUMBER := 0;
BEGIN
    SELECT COUNT(*) 
    INTO v_NUMBER_OF_PLEDGES
    FROM DD_PLEDGE
    JOIN DD_STATUS 
    USING (IDSTATUS)
    WHERE IDDONOR = vIDDONOR
        AND IDSTATUS = 10
        AND PAYMONTHS > 0 ;
    
    IF v_NUMBER_OF_PLEDGES > 0 THEN 
        vRETURN := TRUE;
    ELSE
        vRETURN := FALSE;
    END IF;
END;

DECLARE 
    vIDDONOR DD_PLEDGE.IDDONOR%TYPE := 303;
    vRETURN BOOLEAN;
BEGIN
    DDPAY_SP(vIDDONOR, vRETURN);
    DBMS_OUTPUT.PUT_LINE('Does the donor('||vIDDONOR||') have active pledges with monthly payments?');
    IF (vRETURN) THEN 
      DBMS_OUTPUT.PUT_LINE('Yes, the donor has'); 
    ELSE
      DBMS_OUTPUT.PUT_LINE('No, the donor does not have'); 
    END IF;
END;

/*
Assignment 5-12: Creating a Procedure
Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is the
correct amount. The procedure needs to accept two values as input: a payment amount and a
pledge ID. Based on these inputs, the procedure should confirm that the payment is the correct
monthly increment amount, based on pledge data in the database. If it isn’t, a custom Oracle error
using error number 20050 and the message “Incorrect payment amount - planned payment = ??”
should be raised. The ?? should be replaced by the correct payment amount. The database
query in the procedure should be formulated so that no rows are returned if the pledge isn’t on
a monthly payment plan or the pledge isn’t found. If the query returns no rows, the procedure should
display the message “No payment information.” Test the procedure with the pledge ID 104 and the
payment amount $25. Then test with the same pledge ID but the payment amount $20. Finally, test
the procedure with a pledge ID for a pledge that doesn’t have monthly payments associated with it.
*/
CREATE OR REPLACE 
PROCEDURE DDCKPAY_SP
(
    vIDPLEDGE IN DD_PLEDGE.IDPLEDGE%TYPE,
    vPLEDGEAMT IN DD_PLEDGE.PLEDGEAMT%TYPE
)
IS
    v_PLEDGEAMT DD_PLEDGE.PLEDGEAMT%TYPE := 0;
BEGIN
    SELECT (PLEDGEAMT/PAYMONTHS)
    INTO   v_PLEDGEAMT
    FROM  DD_PLEDGE
    WHERE  IDPLEDGE = vIDPLEDGE
            AND PAYMONTHS > 0;
    
    IF v_PLEDGEAMT <> vPLEDGEAMT THEN
        RAISE_APPLICATION_ERROR(-20050, 'Incorrect payment amount - planned payment '||v_PLEDGEAMT);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Correct payment amount '||v_PLEDGEAMT);
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('No payment information.');
END;

DECLARE 
    vIDPLEDGE       DD_PLEDGE.IDPLEDGE%TYPE := 104;
    vPLEDGEAMT      DD_PAYMENT.PAYAMT%TYPE := 25;
BEGIN
    --DDCKPAY_SP(vIDPLEDGE,vPLEDGEAMT);
    vPLEDGEAMT:= 20;
    DDCKPAY_SP(vIDPLEDGE,vPLEDGEAMT);
    --DDCKPAY_SP(100,vPLEDGEAMT);    
END;


/*
Assignment 5-13: Creating a Procedure
Create a procedure named DDCKBAL_SP that verifies pledge payment information. The procedure
should accept a pledge ID as input and return three values for the specified pledge: pledge
amount, payment total to date, and remaining balance. Test the procedure with an
anonymous block.
*/
CREATE OR REPLACE 
PROCEDURE DDCKBAL_SP
(
    vIDPLEDGE       IN DD_PLEDGE.IDPLEDGE%TYPE,
    vPLEDGEAMT      OUT DD_PAYMENT.PAYAMT%TYPE,
    vPAYMENTTOTAL   OUT DD_PAYMENT.PAYAMT%TYPE, 
    vBALANCE        OUT DD_PAYMENT.PAYAMT%TYPE
)
IS
BEGIN
    SELECT  PLEDGEAMT, TOTAL_PAID, DIFERENCE
    INTO    vPLEDGEAMT, vPAYMENTTOTAL, vBALANCE
    FROM (
        SELECT 
        IDPLEDGE, PLEDGEAMT, (SELECT SUM(PAYAMT) FROM DD_PAYMENT WHERE DD_PLEDGE.IDPLEDGE = DD_PAYMENT.IDPLEDGE ) TOTAL_PAID , 
        PLEDGEAMT - (SELECT SUM(PAYAMT) FROM DD_PAYMENT WHERE DD_PLEDGE.IDPLEDGE = DD_PAYMENT.IDPLEDGE ) DIFERENCE
        FROM DD_PLEDGE
        WHERE IDPLEDGE = vIDPLEDGE
    ) PLEDGE;
END;

DECLARE 
    vIDPLEDGE       DD_PLEDGE.IDPLEDGE%TYPE := 108;
    vPLEDGEAMT      DD_PAYMENT.PAYAMT%TYPE := 0;
    vPAYMENTTOTAL   DD_PAYMENT.PAYAMT%TYPE := 0; 
    vBALANCE        DD_PAYMENT.PAYAMT%TYPE := 0;
BEGIN
    DDCKBAL_SP(vIDPLEDGE,vPLEDGEAMT,vPAYMENTTOTAL,vBALANCE);
    DBMS_OUTPUT.PUT_LINE('vPLEDGEAMT: '||vPLEDGEAMT||',vPAYMENTTOTAL: '||vPAYMENTTOTAL||', vBALANCE: '||vBALANCE);
END;
