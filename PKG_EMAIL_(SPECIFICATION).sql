CREATE OR REPLACE PACKAGE DBADMINDATA.PKG_EMAIL
AS

vcharset		varchar2(100):='utf-8';
vcontent_type	varchar2(100):='text/html'; --text/plain
vsmtp_host		varchar2(100):='test_host';
nsmtp_port		NUMBER:=25;

TYPE attach_info IS RECORD (attach_name		VARCHAR2(40),
							data_type		VARCHAR2(40) DEFAULT 'text/plain',
							attach_content	BLOB);
TYPE attachments IS TABLE OF attach_info;

PROCEDURE SEND_MAIL(p_to			IN VARCHAR2,--,
					p_from			IN VARCHAR2,
					p_subject		IN VARCHAR2,
					p_msg  			IN clob, --chr(10)||chr(13) OR UTL_TCP.crlf EVERY 1000 char
					p_charset		IN varchar2 DEFAULT vcharset,
					p_content_type	IN VARCHAR2 DEFAULT vcontent_type, 
					p_smtp_host 	IN VARCHAR2 DEFAULT vsmtp_host,
					p_smtp_port 	IN NUMBER DEFAULT nsmtp_port,
					p_attach		IN attachments DEFAULT NULL);
				
END PKG_EMAIL;