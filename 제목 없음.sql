CREATE user jun4 -- �ٸ����� ���̵� ��� ���� ����,������ ���� �ο�
IDENTIFIED by "0000";
grant CONNECT,RESOURCE to jun4;

CREATE user HA4 -- �ٸ����� ���̵� ��� ���� ����,������ ���� �ο�
IDENTIFIED by "1111";
grant CONNECT,RESOURCE to HA4;

CREATE user DAN4 -- �ٸ����� ���̵� ��� ���� ����,������ ���� �ο�
IDENTIFIED by "0000";
grant CONNECT,RESOURCE to DAN4;


alter user donghun --DBA ����
DEFAULT TABLESPACE users -- ���̺� ���� ��ġ�� USERS�� �ְڴ� ���ϸ� system DBF �� �����
QUOTA UNLIMITED on users; -- ����Ҽ� �ִ� ���� UNLIMITED���Ѿ���. INTEGER M 1�ް�.

GRANT DBA TO donghun;

alter user hun -- DEV ���� 
DEFAULT TABLESPACE users
QUOTA UNLIMITED on users;

alter user HA4 --�ٸ����� ����
DEFAULT TABLESPACE users
QUOTA UNLIMITED on users;

alter user DAN4 --�ٸ����� ����
DEFAULT TABLESPACE users
QUOTA UNLIMITED on users;

alter user jun4 --�ٸ����� ����
DEFAULT TABLESPACE users
QUOTA UNLIMITED on users;

CREATE table STORES(
ST_CODE NCHAR(4),
ST_NAME NVARCHAR2(100) NOT NULL,
ST_ADDR NVARCHAR2(100)
)TABLESPACE USERS;

-- PRIVARY KEY �������� �߰��ϱ�
ALTER TABLE STORES
ADD CONSTRAINT ST_CODE_PK PRIMARY KEY(ST_CODE);
-- PRIVARY KEY �������� �����ϱ�
ALTER TABLE STORES
DROP CONSTRAINT ST_CODE_PK;

INSERT INTO STORES(ST_CODE, ST_NAME, ST_ADDR) 
VALUES('I001', '�Ƹ���', '��õ�� ����Ȧ�� ���͵�');
INSERT INTO STORES(ST_CODE, ST_NAME, ST_ADDR) 
VALUES(NULL, '�Ƹ���', '��õ�� ����Ȧ�� ���͵�');

--��� ���̺� �˻�
SELECT*FROM USER_TABLES;
--�������� �˻�
SELECT*FROM user_constraints;
--Ư�� ���̺� �˻�
SELECT*FROM user_tAB_COLS WHERE TABLE_NAME = 'STORES' ;

--�÷� ����
ALTER TABLE STORES
DROP COLUMN ST_ADDR;

SELECT
    *
FROM user_col_privs;

--�÷� ����
ALTER TABLE STORES
ADD ST_ADDR NVARCHAR2(100);

--�÷� ������Ʈ
UPDATE STORES SET ST_ADDR='��õ�� ����Ȧ�� ���͵�' WHERE ST_CODE= 'I001';

--�÷� �������� �����ϱ�
ALTER TABLE STORES
MODIFY ST_ADDR NOT NULL;

--���̺��� ������ Ȯ���ϱ�
SELECT*FROM TESTS WHERE T_QTY LIKE '_0%';

--���̺��� �̸��� ���� ȣ���Ҽ� �ֵ��� �г��� �����ϱ� (SYNONYM�� ���� �����ڸ� ��밡��)
CREATE SYNONYM ST FOR donghun.STORES;



SELECT * FROM STORES WHERE ST_ADDR NOT IN('GR');
ROLLBACK;



--�г��� �����ϱ�
DROP SYNONYM ST;

--������ ���� ����� �г����� ����� �� �ֵ��� PUBLIC���� ����
CREATE PUBLIC SYNONYM ST FOR donghun.STORES;

--hun���� �г����� �ָ� �˻� �� �� �ֵ��� ������ ��
GRANT SELECT ON ST TO hun;

--������ ���� hun�� �г������� ��ȸ ����
SELECT*FROM ST;

COMMIT WORK;

SELECT*FROM SC;

SELECT*FROM USER_TABLES;

SELECT*FROM USER_TAB_COLS WHERE TABLE_NAME='STORES';

SELECT*FROM user_constraints WHERE TABLE_NAME='STORES';

SELECT*FROM user_tab_privs_recd;

/* Ư����(Ư������)�� ��ǰ�� �Ǹ� ��Ȳ 
    -- ���� ������Ȳ
    -- ���� ������Ȳ
    ---------------------------------------------------
      ��ǰ�ڵ�     ��ǰ��       �ֹ��Ǽ�       �����
 STEP1 OT GO        GO           OT        OT * GO
    ---------------------------------------------------
*/
-- STEP2~3. ORDERDETAIL(OT)
SELECT  OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        OT.OT_ODCODE AS ORDERS,
        OT.OT_QTY * GO.GO_PRICE AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
WHERE TO_CHAR(OT.OT_ODCODE, 'YYYYMMDD') = '20201015';

-- STEP 4
SELECT  OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        COUNT(OT.OT_ODCODE) AS ORDERS,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
WHERE TO_CHAR(OT.OT_ODCODE, 'YYYYMMDD') = '20201015'
GROUP BY OT.OT_GOCODE, GO.GO_NAME;

-- Ư�� ���� ������Ȳ
SELECT  OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        COUNT(OT.OT_ODCODE) AS ORDERS,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
WHERE TO_CHAR(OT.OT_ODCODE, 'YYYYMM') = '202010'
GROUP BY OT.OT_GOCODE, GO.GO_NAME;

-- Ư�� ����(��, ��)�� ������Ȳ

SELECT  OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        COUNT(OT.OT_ODCODE) AS ORDERS,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
WHERE TO_CHAR(OT.OT_ODCODE, 'YYYYMM') >= '202009' AND 
      TO_CHAR(OT.OT_ODCODE, 'YYYYMM') <= '202010'
GROUP BY OT.OT_GOCODE, GO.GO_NAME;


/*WHERE TO_CHAR(OT.OT_ODCODE, 'YYYYMMDD') >= '20201001' AND
      TO_CHAR(OT.OT_ODCODE, 'YYYYMMDD') <= '20201015'*/

-- STEP 5
CREATE OR REPLACE VIEW SALESINFO
AS
SELECT  OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        OT.OT_ODCODE AS ORDERS,
        OT.OT_QTY * GO.GO_PRICE AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE;

-- Ư�� ���� ������Ȳ
SELECT GOCODE, GONAME, COUNT(ORDERS), SUM(AMOUNT)
FROM SALESINFO
WHERE TO_CHAR(ORDERS, 'YYYYMMDD') = '20201015'
GROUP BY GOCODE, GONAME;

-- Ư�� ���� ������Ȳ
SELECT GOCODE, GONAME, COUNT(ORDERS), SUM(AMOUNT)
FROM SALESINFO
WHERE TO_CHAR(ORDERS, 'YYYYMM') = '202010'
GROUP BY GOCODE, GONAME;

-- Ư�� ����(��, ��)�� ������Ȳ
SELECT GOCODE, GONAME, COUNT(ORDERS), SUM(AMOUNT)
FROM SALESINFO
WHERE TO_CHAR(ORDERS, 'YYYYMMDD') >= '20200920' AND
      TO_CHAR(ORDERS, 'YYYYMMDD') <= '20201015'
GROUP BY GOCODE, GONAME;


SELECT GOCODE, GONAME, COUNT(ORDERS), SUM(AMOUNT)
FROM SALESINFO
WHERE TO_CHAR(ORDERS, 'YYYYMM') >= '202009' AND
      TO_CHAR(ORDERS, 'YYYYMM') <= '202010'
GROUP BY GOCODE, GONAME;


/* Ư�� ��ǰ(GOCODE)�� ���� ���� ���� 
    --------------------------------------
      �����        �ֹ��Ǽ�       �����
      OD OT           OT        OT * GO
    --------------------------------------
*/
SELECT  TO_CHAR(ORDERS, 'YYYYMM') AS ORDERS,
        COUNT(ORDERS) AS CNT,
        SUM(AMOUNT) AS TOTAMOUNT
FROM SALESINFO
WHERE GOCODE = '3001'
GROUP BY TO_CHAR(ORDERS, 'YYYYMM');

/* ���� ���� ���� 
    --------------------------------------
      �����        �ֹ��Ǽ�       �����
      OD OT      CONUNT(OD)    SUM(OT * GO)
    --------------------------------------
*/
-- GROUPING 1
SELECT  TO_CHAR(OD_CODE, 'YYYYMM') AS SALESMONTH, 
        COUNT(OD_CODE) AS SALESCOUNT
FROM OD
GROUP BY TO_CHAR(OD_CODE, 'YYYYMM');

-- GROUPING 2
SELECT  TO_CHAR(OT.OT_ODCODE, 'YYYYMM') AS SALESMONTH,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
GROUP BY TO_CHAR(OT.OT_ODCODE, 'YYYYMM');

-- JOIN 
SELECT SI1.SALESMONTH, SI1.SALESCOUNT, SI2.AMOUNT
FROM (SELECT  TO_CHAR(OD_CODE, 'YYYYMM') AS SALESMONTH, COUNT(OD_CODE) AS SALESCOUNT
        FROM OD
        GROUP BY TO_CHAR(OD_CODE, 'YYYYMM')) SI1
INNER JOIN 
     (SELECT  TO_CHAR(OT.OT_ODCODE, 'YYYYMM') AS SALESMONTH,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT
        FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
        GROUP BY TO_CHAR(OT.OT_ODCODE, 'YYYYMM')) SI2
ON SI1.SALESMONTH = SI2.SALESMONTH;


/* Ư����(ODCODE)�� ����Ʈ ��ǰ(�ǸŰ���) ��Ȳ 
    ------------------------------------------------------
      �����    ��ǰ�ڵ�    ��ǰ��    �Ǹŷ�       �����
        OT      OT  GO      GO       OT         OT*GO
    ------------------------------------------------------
*/       
-- STEP 2~3 JOIN  --> VIEW
SELECT  TO_CHAR(OT.OT_ODCODE, 'YYYYMM') AS SALESMONTH,
        OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        OT.OT_QTY AS QTY,
        OT.OT_QTY * GO.GO_PRICE AS AMOUNT
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE;

-- STEP 4 GROUPING
CREATE OR REPLACE VIEW MONTHLYBEST
AS
SELECT  TO_CHAR(OT.OT_ODCODE, 'YYYYMM') AS SALESMONTH,
        OT.OT_GOCODE AS GOCODE,
        GO.GO_NAME AS GONAME,
        SUM(OT.OT_QTY) AS QTY,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS AMOUNT
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
GROUP BY TO_CHAR(OT.OT_ODCODE, 'YYYYMM'), OT.OT_GOCODE, GO.GO_NAME;


SELECT * 
FROM MONTHLYBEST
WHERE (SALESMONTH, QTY) IN(SELECT SALESMONTH, MAX(QTY) 
                            FROM MONTHLYBEST 
                            GROUP BY SALESMONTH);



-- GROUPING1 --> �Ϻ� �ð��� �ջ�
SELECT  TO_CHAR(OD_CODE, 'YYYYMMDDHH24') AS SALESDAYTIME, 
        COUNT(*) AS ORDERS
FROM OD
GROUP BY TO_CHAR(OD_CODE, 'YYYYMMDDHH24');

-- GROUPING1 --> �ð��� �� ��� �ֹ� ����
SELECT SUBSTR(SALESDAYTIME, 9,2) AS SALESTIME, 
       TO_CHAR(ROUND(AVG(ORDERS),1), '9,990.0') AS ORDERSAVG
FROM (SELECT  TO_CHAR(OD_CODE, 'YYYYMMDDHH24') AS SALESDAYTIME, 
              COUNT(*) AS ORDERS
      FROM OD
      GROUP BY TO_CHAR(OD_CODE, 'YYYYMMDDHH24'))
GROUP BY SUBSTR(SALESDAYTIME, 9,2);

-- GROUPING2 :: �Ϻ� �ð��� �ջ�
SELECT  TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24') AS SALESDAYTIME,
        SUM(OT.OT_QTY * GO.GO_PRICE) AS DAYAVG
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
GROUP BY TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24');

-- GROUPING2 --> �ð��� ���
SELECT  SUBSTR(SALESDAYTIME, 9,2) AS SALESTIME,
        TO_CHAR(ROUND(AVG(DAYAMOUNT), 1), '999,990.0') AS AMOUNTAVG
FROM (SELECT  TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24') AS SALESDAYTIME,
              SUM(OT.OT_QTY * GO.GO_PRICE) AS DAYAMOUNT
      FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
      GROUP BY TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24'))
GROUP BY SUBSTR(SALESDAYTIME, 9,2);

-- GROUPING1 JOIN GROUPING2
SELECT GR1.SALESTIME || ' TIME' AS SALESTIME,
       GR1.ORDERSAVG AS ORDERSAVG,
       GR2.AMOUNTAVG AS AMOUNTAVG
FROM (SELECT SUBSTR(SALESDAYTIME, 9,2) AS SALESTIME, 
             ROUND(AVG(ORDERS),1) AS ORDERSAVG
      FROM (SELECT  TO_CHAR(OD_CODE, 'YYYYMMDDHH24') AS SALESDAYTIME, 
                    COUNT(*) AS ORDERS
            FROM OD
            GROUP BY TO_CHAR(OD_CODE, 'YYYYMMDDHH24'))
        GROUP BY SUBSTR(SALESDAYTIME, 9,2)) GR1
INNER JOIN 
     (SELECT  SUBSTR(SALESDAYTIME, 9,2) AS SALESTIME,
              TO_CHAR(ROUND(AVG(DAYAMOUNT), 1), '999,990') AS AMOUNTAVG
      FROM (SELECT  TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24') AS SALESDAYTIME,
                    SUM(OT.OT_QTY * GO.GO_PRICE) AS DAYAMOUNT
            FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
            GROUP BY TO_CHAR(OT_ODCODE, 'YYYYMMDDHH24'))
        GROUP BY SUBSTR(SALESDAYTIME, 9,2)) GR2
ON GR1.SALESTIME = GR2.SALESTIME;
/* ���Ϻ� �������� 
    --------------------------------
      ����     ����ֹ��Ǽ�  ��ո����
    --------------------------------
*/

--���Ϻ� ��� �ֹ�
CREATE OR REPLACE VIEW AVGORD AS
SELECT TO_CHAR(TO_DATE(SALESDAYTIME,'YYYYMMDD'),'DAY') AS SALESTIME, 
       TO_CHAR(ROUND(AVG(ORDERS),1), '9,990.0') AS ORDERSAVG
FROM (SELECT  TO_CHAR(OD_CODE, 'YYYYMMDD') AS SALESDAYTIME, 
              COUNT(*) AS ORDERS
      FROM OD
      GROUP BY TO_CHAR(OD_CODE, 'YYYYMMDD'))
GROUP BY TO_CHAR(TO_DATE(SALESDAYTIME,'YYYYMMDD'),'DAY');

--���Ϻ� ��� ����
CREATE OR REPLACE VIEW AVGAMOUNT AS
SELECT  TO_CHAR(TO_DATE(SALESDAYTIME,'YYYYMMDD'),'DAY') AS SALESTIME,
        TO_CHAR(ROUND(AVG(DAYAMOUNT), 1), '999,990') AS AMOUNTAVG
FROM (SELECT  TO_CHAR(OT_ODCODE, 'YYYYMMDD') AS SALESDAYTIME,
              SUM(OT.OT_QTY * GO.GO_PRICE) AS DAYAMOUNT
      FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE
      GROUP BY TO_CHAR(OT_ODCODE, 'YYYYMMDD'))
GROUP BY TO_CHAR(TO_DATE(SALESDAYTIME,'YYYYMMDD'),'DAY');

SELECT
A1.SALESTIME AS ����,
ORDERSAVG AS ����ֹ��Ǽ�,
AMOUNTAVG AS ��ո����
FROM AVGORD A1 INNER JOIN AVGAMOUNT A2 ON A1.SALESTIME = A2.SALESTIME;

SELECT
EM_CODE AS ����ڵ�,
EM_NAME AS �����,
COALESCE(HI_STATE,0) AS �α��ο���
FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE
;
------------------------------------------------------------
SELECT
����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGIN
FROM (SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����, HI_STATE AS �α��ο���
FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE)
WHERE �α��ο��� = 1
GROUP BY ����ڵ�,�����;

SELECT
����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGOUT
FROM (SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����, HI_STATE AS �α��ο���
FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE)
WHERE �α��ο��� = -1
GROUP BY ����ڵ�,�����;
/* 1. Ư�� ������ ������ �α��ΰ� �α׾ƿ� Ƚ�� ��� ��� 
    ---------------------------------------------
      ����ڵ�   �����   �α���Ƚ��   �α׾ƿ� Ƚ��
    ---------------------------------------------
*/ 
SELECT
EM_CODE AS ����ڵ�,EM_NAME AS �����,COALESCE(A3.LOGIN,0) AS LOGIN,COALESCE(A3.LOGOUT,0) AS LOGOUT

FROM(SELECT
COALESCE(A1.����ڵ�,A2.����ڵ�) AS ����ڵ�,COALESCE(A1.�����,A2.�����) AS �����,COALESCE(A1.LOGIN,0) AS LOGIN,COALESCE(A2.LOGOUT,0) AS LOGOUT

FROM (  SELECT ����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGIN ,STNAME AS STNAME
        FROM (  SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����,COALESCE(HI_STATE,0) AS �α��ο���,HI.HI_EMSTCODE AS STNAME
                FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE  WHERE HI_STATE = 1)
    GROUP BY ����ڵ�,�����,STNAME) A1
FULL OUTER JOIN (SELECT ����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGOUT ,STNAME AS STNAME2
            FROM (  SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����, COALESCE(HI_STATE,0) AS �α��ο��� ,HI.HI_EMSTCODE AS STNAME
                    FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE   WHERE HI_STATE = -1)
            GROUP BY ����ڵ�,�����,STNAME) A2 
ON A1.����ڵ� = A2.����ڵ�) A3

RIGHT OUTER JOIN EM         ON A3.����ڵ�  = EM.EM_CODE

WHERE EM_STCODE = 'D001';

SELECT *
FROM HI;

/* 2. Ư�� ������ ��� ������ �α��� Ƚ���� ���� ���� ������ ���� ��� 
    ----------------------------------------
      ����ڵ�   �����   �α���Ƚ��   ������
    ----------------------------------------
*/ 
    -- �� ���� ����Ǯ��
    SELECT ����ڵ�,�����,LOGIN,"LEVEL"
    FROM(SELECT ����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGIN ,STNAME AS STCODE ,"LEVEL" AS "LEVEL"
        FROM (  SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����,
                COALESCE(HI_STATE,0) AS �α��ο���,
                HI.HI_EMSTCODE AS STNAME, 
                EM_LEVEL AS "LEVEL"
                FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE)
    WHERE �α��ο��� = 1
    GROUP BY ����ڵ�,�����,STNAME,"LEVEL")
    
    WHERE STCODE = 'D002' AND
    (LOGIN,STCODE) IN( SELECT MAX(LOGIN),STCODE
                        FROM( SELECT ����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGIN ,STNAME AS STCODE ,"LEVEL" AS "LEVEL"
                                FROM (   SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����,
                                         COALESCE(HI_STATE,0) AS �α��ο���,
                                         HI.HI_EMSTCODE AS STNAME, 
                                         EM_LEVEL AS "LEVEL"
                                         FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE)    WHERE �α��ο��� = 1
                                         GROUP BY ����ڵ�,�����,STNAME,"LEVEL") group by STCODE);
                 
--�� Ȱ���Ͽ� ����Ǯ��

CREATE OR REPLACE VIEW LOGINMAX AS
SELECT ����ڵ� AS ����ڵ�, ����� AS �����, COUNT(�α��ο���) AS LOGIN ,STNAME AS STCODE ,"LEVEL" AS "LEVEL"
        FROM (  SELECT EM_CODE AS ����ڵ�, EM_NAME AS �����,
                COALESCE(HI_STATE,0) AS �α��ο���,
                HI.HI_EMSTCODE AS STNAME, 
                EM_LEVEL AS "LEVEL"
                FROM HI RIGHT OUTER JOIN EM ON HI.HI_EMCODE =EM.EM_CODE)
    WHERE �α��ο��� = 1
    GROUP BY ����ڵ�,�����,STNAME,"LEVEL";
    
SELECT ����ڵ�,�����,LOGIN,"LEVEL"
FROM LOGINMAX
WHERE STCODE = 'D002' AND 
(STCODE,LOGIN) IN (SELECT STCODE,MAX(LOGIN) AS LOGMAX FROM LOGINMAX GROUP BY STCODE);

/* 3. Ư�� ������ ��� ������ ������� ������ �ǸŽ����� ���
    ----------------------------------------
      ����ڵ�   �����   �ֹ��Ǽ�    �����
       EM        EM      OD       OT GO
    ----------------------------------------
*/ 
CREATE OR REPLACE VIEW B1 AS
SELECT
EM_CODE AS ����ڵ�,
EM_NAME AS �����,
OD_CODE AS ODCODE,
EM_STCODE AS STCODE,
OT_QTY * go.go_price AS �����
FROM "EM" INNER JOIN OD ON "EM".EM_CODE = OD_EMCODE
          INNER JOIN OT ON OD_CODE = OT_ODCODE
          INNER JOIN GO ON OT_GOCODE = GO_CODE;
          
SELECT
A1.����ڵ�,A1.�����,�ֹ��Ǽ�,A1.�����
FROM (  SELECT EM_CODE AS ����ڵ�,����� AS �����,SUM(�����) AS �����,EM_STCODE AS STCODE
        FROM B1 RIGHT OUTER JOIN EM ON "EM".EM_CODE = ����ڵ�
        GROUP BY EM_CODE, �����,EM_STCODE) A1

INNER JOIN (SELECT OD_EMCODE AS ����ڵ�,COUNT(OD_CODE) AS �ֹ��Ǽ� 
            FROM OD GROUP BY OD_EMCODE) A2 
    ON A1.����ڵ� = A2. ����ڵ�

WHERE STCODE = 'D002';

/* 4. ��� ��ǰ�� ���� ���
    --------------------------------------------
      ��ǰ�ڵ�   ��ǰ��   ����    ���     �������
      GO        GO      GO     SC        SC
    --------------------------------------------
*/ 
SELECT
GO_CODE AS ��ǰ�ڵ�,
go.go_name AS ��ǰ��,
go.go_price AS ����,
COALESCE(sc.sc_stocks,0) AS ���,
--COALESCE(sc.sc_expire,TO_DATE('00010101000000')) AS �������
COALESCE(TO_CHAR(sc.sc_expire,'YYYYMMDDHH24MISS'),'��� ���� ��ǰ') AS �������
FROM GO LEFT OUTER JOIN SC ON GO_CODE = SC_GOCODE;

/* 5. 4�� ����� �ǸŰ����� ��ǰ������ ���
    --------------------------------------------
      ��ǰ�ڵ�   ��ǰ��   ����    ���     �������
    --------------------------------------------
*/
SELECT
GO_CODE AS ��ǰ�ڵ�,
go.go_name AS ��ǰ��,
go.go_price AS ����,
sc.sc_stocks AS ���,
sc.sc_expire AS �������
FROM GO LEFT OUTER JOIN SC ON GO_CODE = SC_GOCODE
WHERE  sc.sc_expire >= SYSDATE AND sc.sc_stocks >0;


SELECT
    *
FROM em;
-- �α��� �Ҷ� �Է��� ���̵� �ִ��� Ȯ�� ������ 1
SELECT COUNT(*) AS ISEMCODE FROM EM WHERE EM_STCODE = 'D001' AND EM_CODE = 'G002';
-- �α��� �Ҷ� �Է��� ��й�ȣ�� �´��� Ȯ�� ������ 1
SELECT COUNT(*) AS ISACCESS FROM EM WHERE EM_STCODE = 'D001' AND EM_CODE = 'G002' AND EM_PWD = '0002';

-- �Ѵ� ������ �α��� => HI�� INSERT
INSERT INTO HI(HI_EMCODE,HI_ACCDATE,HI_STATE, HI_EMSTCODE) VALUES('G002',DEFAULT,1,'D001');

CREATE OR REPLACE VIEW LOGINFO AS
SELECT 
em.em_stcode STCODE,
em_code AS EMCODE,
em_name AS EMNAME,
em_level AS LEVELS ,
max(hi.hi_accdate) AS ACCESSTIME
FROM EM INNER JOIN HI ON EM.EM_STCODE = HI.HI_EMSTCODE AND EM.EM_CODE = HI.HI_EMCODE
group by em.em_stcode,em_code,em_name ,em_level ;

SELECT STCODE ,accesstime AS ACCESSTIME, EMCODE AS EMCODE, EMNAME AS EMNAME,LEVELS AS LEVELS FROM LOGINFO WHERE stcode = 'D001' AND EMCODE = 'G002';

SELECT * FROM EM ;

SELECT * FROM em;
COMMIT;
SELECT * FROM HI;

DELETE FROM EM WHERE EM_CODE ='G009';





                -----------------
CREATE OR REPLACE VIEW HISGOINFO AS 
SELECT 
TO_CHAR(OT_ODCODE,'YYYYMMDD') AS ODCODE,
GO_CODE AS GOCODE,
GO_NAME AS GONAME,
GO_PRICE AS GOPRICE,
OT_QTY AS QTY,
GO_PRICE*OT_QTY AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE;

SELECT * FROM HI;

CREATE OR REPLACE VIEW HISGO AS 
SELECT 
TO_CHAR(OT_ODCODE,'YYYYMM') AS ODCODE,
GO_CODE AS GOCODE,
GO_NAME AS GONAME,
GO_PRICE AS GOPRICE,
OT_QTY AS QTY,
GO_PRICE*OT_QTY AS AMOUNT 
FROM OT INNER JOIN GO ON OT.OT_GOCODE = GO.GO_CODE;
                





SELECT GO_CODE AS �ڵ�, GO_NAME AS ��ǰ��,GO_PRICE AS ����, MIN(SC_EXPIRE) AS ������� 
FROM GO INNER JOIN SC ON GO_CODE = SC_GOCODE 
WHERE GO_CODE = '1001' AND SC_EXPIRE > SYSDATE GROUP BY GO_CODE,GO_NAME,GO_PRICE;



SELECT * FROM OD;
SELECT * FROM Ot;

INSERT INTO OD(OD_CODE,OD_EMSTCODE,OD_EMCODE,OD_CMCODE,OD_STATE) 
VALUES(DEFAULT,'D001','G002','00000','P');
SELECT * FROM SC;
COMMIT;

SELECT * FROM OD;



-- OD�� �Է��ϸ� OD_CODE�� �ڵ����� �����ǰ� �����
-- ��� ����� �̾� �������ؼ� OD���� OD_CODE�� ���� ū�� �̾Ƽ� ODCODE�� ���� ����
--CREATE OR REPLACE PROCEDURE ORDMAKE
--(STCODE IN OD.OD_EMSTCODE%TYPE,
--EMCODE IN OD.OD_EMCODE%TYPE,
--CMCODE IN OD.OD_CMCODE%TYPE,
--ODSTATE IN OD.OD_STATE%TYPE,
--ODCODE OUT NVARCHAR2
--)
--IS
--
--BEGIN
--INSERT INTO OD(OD_EMSTCODE, OD_EMCODE, OD_CMCODE, OD_STATE , OD_CODE) 
--VALUES(STCODE,EMCODE,CMCODE,ODSTATE,DEFAULT);
--
--SELECT TO_CHAR(MAX(OD_CODE),'YYYYMMDDHH24MISS') INTO ODCODE FROM OD
--WHERE OD_EMSTCODE = STCODE AND OD_EMCODE = EMCODE;
--END ORDMAKE;


--drop PROCEDURE ORDMAKE;


--SET SERVEROUTPUT ON;
--
--DECLARE
--ODCODE NCHAR(14);
--
--BEGIN
--ORDMAKE('D001','G001','C0000','P',ODCODE);
--DBMS_OUTPUT.put_line(ODCODE);
--END;

ROLLBACK;
DELETE FROM OD WHERE TO_CHAR(OD_CODE,'YYYYMMDD') = '20201102';
SELECT
    *
FROM Od;

--CREATE OR REPLACE PROCEDURE INS_OT(
--  ODCODE    IN  NVARCHAR2,
--  GOCODE    IN  OT.OT_GOCODE%TYPE,
--  GOQTY     IN  OT.OT_QTY%TYPE,
--  OTSTATE   IN  OT.OT_STATE%TYPE
--)
--IS
--
--BEGIN
--    INSERT INTO OT(OT_ODCODE, OT_GOCODE, OT_QTY, OT_STATE) 
--    VALUES(TO_DATE(ODCODE, 'YYYYMMDDHH24MISS'), GOCODE, GOQTY, OTSTATE);
--END INS_OT;





--SET SERVEROUTPUT ON;
--DECLARE
--ODCODE NCHAR(14) := '20201102134829';
--GOCODE NCHAR(4) := '1001';
--QTY NUMBER:= 2;
--OTSTATE NCHAR(1):= 'P';
--BEGIN
--INS_OT(ODCODE,GOCODE,QTY,OTSTATE);
--SELECT
--ODCODE,GOCODE,QTY,OTSTATE INTO ODCODE,GOCODE,QTY,OTSTATE
--FROM OT WHERE OT_ODCODE = '20201102134829';
--DBMS_OUTPUT.PUT_LINE('ODCODE : '||ODCODE);
--DBMS_OUTPUT.PUT_LINE('GOCODE : '||GOCODE);
--DBMS_OUTPUT.PUT_LINE('QTY : '||QTY);
--DBMS_OUTPUT.PUT_LINE('STATE : '||OTSTATE);
--END;

--

CREATE TABLE STUDENT(
ST_NAME NVARCHAR2(5),
ST_AGE NUMBER(3,0)
)TABLESPACE USERS;

SELECT
    *
FROM students;



UPDATE HEEDONG.STUDENT SET ST_AGE = '24' WHERE ST_NAME='������';
UPDATE HEEDONG.STUDENT SET ST_AGE = 25 WHERE ST_NAME='������';

SELECT
    *
FROM user_col_privs;
UPDATE STUDENTS SET ST_AGE = '60',ST_NAME = '������' WHERE ST_NAME='����';

CREATE TABLE INPUTT(
INPUT1 NVARCHAR2(20),
INPUT2 NVARCHAR2(20)
)TABLESPACE USERS;

COMMIT;

DELETE FROM IT ;

SELECT * FROM IT;

CREATE TABLE MEMBERT(
MB_CODE NCHAR(4),
MB_PWD NCHAR(4),
MB_NAME NVARCHAR2(5),
MB_BIRTH  NVARCHAR2(10),
MB_GENDER NCHAR(2),
MB_EMAIL NVARCHAR2(30)
)TABLESPACE USERS;

ALTER TABLE MEMBERT
MODIFY MB_BIRTH NVARCHAR2(10);

SELECT
    *
FROM MB;

DELETE FROM MB;
COMMIT;
ROLLBACK;
