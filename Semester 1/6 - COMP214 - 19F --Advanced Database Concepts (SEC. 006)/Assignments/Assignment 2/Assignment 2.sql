/*301093125 - CAIQUE BISPO FERREIRA*/

/*
Assignment 3-9: Retrieving Pledge Totals
Create a PL/SQL block that retrieves and displays information for a specific project based on
Project ID. Display the following on a single row of output: project ID, project name, number of
pledges made, total dollars pledged, and the average pledge amount.
*/

DECLARE 
    vID_PROJ                 DD_PROJECT.IDPROJ%TYPE;
    vIDPROJ                 DD_PROJECT.IDPROJ%TYPE;
    vPROJNAME               DD_PROJECT.PROJNAME%TYPE;
    vNUMBER_PLEDGES_MADE    NUMBER;
    vTOTAL_DOLLARS_PLEDGED  DD_PLEDGE.PLEDGEAMT%TYPE;
    vAVG_DOLLARS_PLEDGED    DD_PLEDGE.PLEDGEAMT%TYPE;
BEGIN
    SELECT  IDPROJ, PROJNAME, NUMBER_PLEDGES_MADE, TOTAL_DOLLARS_PLEDGED, AVG_DOLLARS_PLEDGED 
    INTO vIDPROJ, vPROJNAME, vNUMBER_PLEDGES_MADE, vTOTAL_DOLLARS_PLEDGED, vAVG_DOLLARS_PLEDGED 
    FROM (
            SELECT 
                IDPROJ,
                PROJNAME, 
                ( SELECT COUNT(*)              FROM DD_PLEDGE WHERE DD_PROJECT.IDPROJ = DD_PLEDGE.IDPROJ ) AS NUMBER_PLEDGES_MADE ,
                ( SELECT NVL(SUM(PLEDGEAMT),0) FROM DD_PLEDGE WHERE DD_PROJECT.IDPROJ = DD_PLEDGE.IDPROJ ) AS TOTAL_DOLLARS_PLEDGED,
                ( SELECT NVL(AVG(PLEDGEAMT),0) FROM DD_PLEDGE WHERE DD_PROJECT.IDPROJ = DD_PLEDGE.IDPROJ ) AS AVG_DOLLARS_PLEDGED 
            FROM DD_PROJECT
            WHERE IDPROJ = &vID_PROJ
        ) PROJ;
    
     DBMS_OUTPUT.PUT_LINE('IDPROJ: '||vIDPROJ||',PROJNAME: '||vPROJNAME||', NUMBER_PLEDGES_MADE: '||vNUMBER_PLEDGES_MADE||', TOTAL_DOLLARS_PLEDGED:'||vTOTAL_DOLLARS_PLEDGED||', AVG_DOLLARS_PLEDGED:'||vAVG_DOLLARS_PLEDGED);
END;

/*
Assignment 3-10: Adding a Project
Create a PL/SQL block to handle adding a new project. Create and use a sequence named
DD_PROJID_SEQ to handle generating and populating the project ID. The first number issued
by this sequence should be 530, and no caching should be used. Use a record variable to
handle the data to be added. Data for the new row should be the following: project name = HK
Animal Shelter Extension, start = 1/1/2013, end = 5/31/2013, and fundraising goal = $65,000.
Any columns not addressed in the data list are currently unknown.
*/
CREATE SEQUENCE DD_PROJID_SEQ START WITH 530 INCREMENT BY 1 NOCACHE;

DECLARE
 TYPE type_DD_PROJECT IS RECORD (
      IDPROJ  DD_PROJECT.IDPROJ%TYPE,
      PROJNAME DD_PROJECT.PROJNAME%TYPE,
      PROJSTARTDATE DD_PROJECT.PROJSTARTDATE%TYPE,
      PROJENDDATE  DD_PROJECT.PROJENDDATE%TYPE,
      PROJFUNDGOAL DD_PROJECT.PROJFUNDGOAL%TYPE,
      PROJCOORD DD_PROJECT.PROJCOORD%TYPE
  );
  rec_DD_PROJECT type_DD_PROJECT;
BEGIN 
    DELETE FROM DD_PROJECT WHERE PROJNAME = 'HK Animal Shelter Extension';
    rec_DD_PROJECT.IDPROJ           := DD_PROJID_SEQ.NEXTVAL;
    rec_DD_PROJECT.PROJNAME         := 'HK Animal Shelter Extension';
    rec_DD_PROJECT.PROJSTARTDATE    := TO_DATE('1/1/2013','mm/dd/yyyy');
    rec_DD_PROJECT.PROJENDDATE      := TO_DATE('5/31/2013','mm/dd/yyyy');
    rec_DD_PROJECT.PROJFUNDGOAL     := 65000;
    INSERT INTO DD_PROJECT values rec_DD_PROJECT;   
    COMMIT;
    DBMS_OUTPUT.PUT_LINE( 'IDPROJ: '||rec_DD_PROJECT.IDPROJ||','||
                           'PROJNAME: '|| rec_DD_PROJECT.PROJNAME||','||
                           'PROJSTARTDATE: '||  rec_DD_PROJECT.PROJSTARTDATE||','||
                           'PROJENDDATE: '||   rec_DD_PROJECT.PROJENDDATE||','||
                           'PROJFUNDGOAL: '||rec_DD_PROJECT.PROJFUNDGOAL||','||
                           'PROJCOORD: '||rec_DD_PROJECT.PROJCOORD
                          );
END;

/*
Assignment 3-11: Retrieving and Displaying Pledge Data
Create a PL/SQL block to retrieve and display data for all pledges made in a specified month.
One row of output should be displayed for each pledge. Include the following in each row
of output:
• Pledge ID, donor ID, and pledge amount
• If the pledge is being paid in a lump sum, display “Lump Sum.”
• If the pledge is being paid in monthly payments, display “Monthly - #” (with the #
representing the number of months for payment).
• The list should be sorted to display all lump sum pledges first.
*/
DECLARE 
    vDATE1 DATE := '01-OCT-12';
    vDATE2 DATE := '31-OCT-12';
    
    TYPE type_DD_PLEDGE IS RECORD (
        IDPLEDGE DD_PLEDGE.IDPLEDGE%TYPE,
        IDDONOR  DD_PLEDGE.IDDONOR%TYPE,
        PLEDGEAMT  DD_PLEDGE.PLEDGEAMT%TYPE,
        DESCRIPTION VARCHAR(20)
      );
    rec_DD_PLEDGE type_DD_PLEDGE;
    
    CURSOR DD_PLEDGE_DET IS 
        SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, DESCRIPTION
        FROM (
            SELECT IDPLEDGE, IDDONOR, PLEDGEAMT,
            (CASE WHEN PAYMONTHS = 0 THEN 'Lump Sum.'
                  WHEN PAYMONTHS > 0 THEN 'Monthly - '||PAYMONTHS
            END) DESCRIPTION
            FROM DD_PLEDGE
            WHERE PLEDGEDATE BETWEEN vDATE1 AND vDATE2
            ORDER BY 4
            );
BEGIN
    OPEN DD_PLEDGE_DET;
    LOOP
        FETCH DD_PLEDGE_DET INTO rec_DD_PLEDGE;
        EXIT WHEN DD_PLEDGE_DET%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE( 'IDPLEDGE: '||rec_DD_PLEDGE.IDPLEDGE||','||
                   'IDDONOR: '|| rec_DD_PLEDGE.IDDONOR||','||
                   'PLEDGEAMT: '||  rec_DD_PLEDGE.PLEDGEAMT||','||
                   'DESCRIPTION: '||   rec_DD_PLEDGE.DESCRIPTION);
    END LOOP;
    CLOSE DD_PLEDGE_DET;
END;

/*
Assignment 3-12: Retrieving a Specific Pledge
Create a PL/SQL block to retrieve and display information for a specific pledge. Display the
pledge ID, donor ID, pledge amount, total paid so far, and the difference between the pledged
amount and total paid amount.
*/
DECLARE 
    vID_PLEDGE          DD_PLEDGE.IDPLEDGE%TYPE;
    vIDPLEDGE           DD_PLEDGE.IDPLEDGE%TYPE;
    vIDDONOR            DD_PLEDGE.IDDONOR%TYPE;
    vPLEDGEAMT          DD_PLEDGE.PLEDGEAMT%TYPE;
    vTOTAL_PAID         DD_PLEDGE.PLEDGEAMT%TYPE;
    vDIFERENCE          DD_PLEDGE.PLEDGEAMT%TYPE;
BEGIN
    SELECT IDPLEDGE, IDDONOR, PLEDGEAMT, TOTAL_PAID, DIFERENCE
    INTO vIDPLEDGE, vIDDONOR, vPLEDGEAMT, vTOTAL_PAID, vDIFERENCE
    FROM (
            SELECT 
            IDPLEDGE, IDDONOR, PLEDGEAMT, (SELECT SUM(PAYAMT) FROM DD_PAYMENT WHERE DD_PLEDGE.IDPLEDGE = DD_PAYMENT.IDPLEDGE ) TOTAL_PAID , 
            PLEDGEAMT - (SELECT SUM(PAYAMT) FROM DD_PAYMENT WHERE DD_PLEDGE.IDPLEDGE = DD_PAYMENT.IDPLEDGE ) DIFERENCE
            FROM DD_PLEDGE
            WHERE IDPLEDGE = &vID_PLEDGE
        ) PLEDGE;
    
     DBMS_OUTPUT.PUT_LINE('IDPLEDGE: '||vIDPLEDGE||',IDDONOR: '||vIDDONOR||', PLEDGEAMT: '||vPLEDGEAMT||', TOTAL_PAID:'||vTOTAL_PAID||', DIFERENCE:'||vDIFERENCE);
END;


/*
Assignment 3-13: Modifying Data
Create a PL/SQL block to modify the fundraising goal amount for a specific project. In addition,
display the following information for the project being modified: project name, start date,
previous fundraising goal amount, and new fundraising goal amount.
*/
DECLARE 
    vID_PROJ                DD_PROJECT.IDPROJ%TYPE;
    vPROJNAME               DD_PROJECT.PROJNAME%TYPE;
    vPROJSTARTDATE          DD_PROJECT.PROJSTARTDATE%TYPE;
    vPROJFUNDGOAL           DD_PROJECT.PROJFUNDGOAL%TYPE;
    vOLD_PROJFUNDGOAL           DD_PROJECT.PROJFUNDGOAL%TYPE;
    vNEW_PROJFUNDGOAL           DD_PROJECT.PROJFUNDGOAL%TYPE;
BEGIN
    vID_PROJ := 500;
    vNEW_PROJFUNDGOAL :=8000 ;
    
    SELECT PROJFUNDGOAL
    INTO vOLD_PROJFUNDGOAL
    FROM DD_PROJECT
    WHERE IDPROJ = vID_PROJ;

    UPDATE DD_PROJECT SET PROJFUNDGOAL = vNEW_PROJFUNDGOAL
    WHERE IDPROJ = vID_PROJ;
    COMMIT;
    
    SELECT   PROJNAME,   PROJSTARTDATE ,  PROJFUNDGOAL  
    INTO    vPROJNAME,  vPROJSTARTDATE , vPROJFUNDGOAL  
    FROM DD_PROJECT
    WHERE IDPROJ = vID_PROJ;
    
    DBMS_OUTPUT.PUT_LINE('PROJNAME: '||vPROJNAME||', PROJSTARTDATE: '||vPROJSTARTDATE||', OLD_PROJFUNDGOAL:'||vOLD_PROJFUNDGOAL||', NEW_PROJFUNDGOAL:'||vPROJFUNDGOAL);
END;
