-- phpMyAdmin SQL Dump
-- version 4.7.9
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 22, 2020 at 11:05 AM
-- Server version: 5.7.21
-- PHP Version: 5.6.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `scoolwhool`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `add_update_admin_user_master_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_admin_user_master_master` (IN `_aum_id` INT(11), IN `_aum_fullname` VARCHAR(45), IN `_aum_gender` VARCHAR(45), IN `_aum_contactno` VARCHAR(45), IN `_aum_email` VARCHAR(45), IN `_aum_password` VARCHAR(45), IN `_aum_user_role` INT(11), IN `_aum_status` TINYINT(2), IN `_aum_insdt` DATETIME, IN `_aum_insrid` INT(11), IN `_aum_logdt` DATETIME, IN `_aum_logrid` INT(11), IN `_aum_last_login` DATETIME, IN `_aum_last_logout` DATETIME, OUT `_ret` TINYINT(2))  BEGIN
DECLARE flag bool;
    DECLARE mobile varchar(50);
    DECLARE email varchar(50);
    DECLARE msg text;
   
    SET _ret = 0;
    IF EXISTS (SELECT aum_id from admin_user_master Where aum_contactno = _aum_contactno or aum_email = _aum_email)
    THEN

    
			  IF EXISTS (SELECT aum_id from admin_user_master Where aum_contactno = _aum_contactno)
              THEN 
				IF(_aum_id > 0)
                THEN
					SET mobile = (SELECT aum_contactno FROM admin_user_master Where aum_id = _aum_id);
                    IF(mobile = _aum_contactno)
                    THEN
						SET flag = false;
					ELSE
						SET flag = true;
                        SET msg = "1Mobile";
                        SET _ret = 1;
                    END IF;
				ELSE
					SET flag = true;
					SET _ret = 1;
                    SET msg = "2Mobile";
                END IF;
				
			  ELSE
				IF (_aum_email = "")
				  THEN 
					SET flag = false;
				  ELSE
					 IF EXISTS (SELECT aum_id from admin_user_master Where aum_email = _aum_email)
					 THEN 
						IF(_aum_id > 0)
						THEN
							SET email = (SELECT aum_email FROM admin_user_master Where aum_id = _aum_id);
							IF(email = _aum_email)
							THEN
								SET flag = false;
							ELSE
								SET flag = true;
								SET _ret =2;
                                SET msg = "3Email";
							END IF;
						ELSE
							SET flag = true;
							SET _ret = 2;
                            SET msg = "4Email";
						END IF;
						
					 ELSE
						SET flag = false;
                     END IF;
				 END IF;
              END IF;
	ELSE
		
			SET flag = false;
			SET _ret = 3;
		
		
    END IF;
    
    IF(flag = false)
    THEN
		IF(_aum_id > 0)
        THEN
			Update admin_user_master set aum_fulname=_aum_fulname,aum_gender=_aum_gender,aum_contactno=_aum_contactno,aum_email=_aum_email,aum_password=_aum_password,aum_user_role=_aum_user_role,aum_status=_aum_status,aum_logdt=_aum_logdt,aum_logrid=_aum_logrid where aum_id=_aum_id;
			
            SET _ret = 5;
        ELSE
        Insert into admin_user_master values(null,_aum_fulname,_aum_gender,_aum_contactno,_aum_email,_aum_password,_aum_user_role,_aum_status,_aum_insdt,_aum_insrid,_aum_logdt,_aum_logrid,_aum_last_login,_aum_last_logout);
			
            SET _ret = 4;
        END IF;
    ELSE
		
        select msg AS '** DEBUG:';
    END IF;
END$$

DROP PROCEDURE IF EXISTS `add_update_board_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_board_master` (IN `_board_id` INT(11), IN `_board_name` VARCHAR(45), IN `_board_insdt` DATETIME, IN `_board_insip` VARCHAR(45), IN `_board_insrid` INT(11), IN `_board_logdt` DATETIME, IN `_board_logip` VARCHAR(45), IN `_board_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _boardval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _boardval = true;
			            
			IF EXISTS(SELECT board_id FROM board_master WHERE board_name = _board_name)
			THEN
				 SET _ret = 1;
                 set _boardval = false;
			END IF;
				
                IF(_boardval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_board_id = 0 )
              THEN
					Insert into board_master
					values(null,_board_name,_board_insdt,_board_insip,_board_insrid,_board_logdt,_board_logip,_board_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_board_id != 0)
              THEN
					Update board_master set board_name=_board_name,board_logdt=_board_logdt,board_logip=_board_logip,board_logrid  =_board_logrid  where board_id=_board_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_country`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_country` (IN `_country_id` INT(11), IN `_country_name` VARCHAR(100), IN `_country_insdt` DATETIME, IN `_country_insrid` INT(11), IN `_country_logdt` DATETIME, IN `_country_logrid` INT(11), OUT `_RET` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT country_id FROM country_master WHERE country_name=_country_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_country_id = 0 )
              THEN
						INSERT INTO country_master VALUES(NULL,_country_name,_country_insdt,_country_insrid,_country_logdt,_country_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_country_id != 0)
              THEN
					UPDATE country_master SET country_name=_country_name ,  country_logdt=_country_logdt , country_logrid=_country_logrid where country_id=_country_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `add_update_distric`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_distric` (IN `_distric_id` INT(11), IN `_distric_state_id` INT(11), IN `_distric_name` VARCHAR(100), IN `_distric_insdt` DATETIME, IN `_distric_insrid` INT(11), IN `_distric_logdt` DATETIME, IN `_distric_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
				IF EXISTS(SELECT distric_id FROM distric_master WHERE distric_name=_distric_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_distric_id = 0 )
              THEN
						INSERT INTO distric_master VALUES(NULL,_distric_state_id , _distric_name,_distric_insdt,_distric_insrid,_distric_logdt,_distric_logrid);
                    SET _ret = 2;
			   END IF;       
              	
		END IF; 
         IF(_distric_id != 0)
              THEN
					UPDATE distric_master SET distric_state_id=_distric_state_id , distric_name=_distric_name ,  distric_logdt=_distric_logdt , distric_logrid=_distric_logrid where distric_id=_distric_id;
					SET _ret = 3;
				END IF;
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `add_update_language_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_language_master` (IN `_language_id` INT(11), IN `_language_name` VARCHAR(45), IN `_language_insdt` DATETIME, IN `_language_insip` VARCHAR(45), IN `_language_insrid` INT(11), IN `_language_logdt` DATETIME, IN `_language_logip` VARCHAR(45), IN `_language_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT language_id FROM language_master WHERE language_name=_language_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_language_id = 0 )
              THEN
						INSERT INTO language_master VALUES(NULL,_language_name,_language_insdt,_language_insip,_language_insrid,_language_logdt,_language_logip,_language_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_language_id != 0)
              THEN
					UPDATE language_master SET language_name=_language_name ,  language_logdt=_language_logdt ,language_logip=_language_logip , language_logrid=_language_logrid where language_id=_language_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `add_update_medium_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_medium_master` (IN `_medium_id` INT(11), IN `_medium_name` VARCHAR(45), IN `_medium_insdt` DATETIME, IN `_medium_insip` VARCHAR(45), IN `_medium_insrid` INT(11), IN `_medium_logdt` DATETIME, IN `_medium_logip` VARCHAR(45), IN `_medium_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _mediumval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _mediumval = true;
			            
			IF EXISTS(SELECT medium_id FROM medium_master WHERE medium_name = _medium_name)
			THEN
				 SET _ret = 1;
                 set _mediumval = false;
			END IF;
				
                IF(_mediumval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_medium_id = 0 )
              THEN
					Insert into medium_master
					values(null,_medium_name,_medium_insdt,_medium_insip,_medium_insrid,_medium_logdt,_medium_logip,_medium_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_medium_id != 0)
              THEN
					Update medium_master set medium_name=_medium_name,medium_logdt=_medium_logdt,medium_logip=_medium_logip,medium_logrid  =_medium_logrid  where medium_id=_medium_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_standard_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_standard_master` (IN `_standard_id` INT(11), IN `_standard_name` VARCHAR(45), IN `_standard_insdt` DATETIME, IN `_standard_insip` VARCHAR(45), IN `_standard_insrid` INT(11), IN `_standard_logdt` DATETIME, IN `_standard_logip` VARCHAR(45), IN `_standard_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _standardval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _standardval = true;
			            
			IF EXISTS(SELECT standard_id FROM standard_master WHERE standard_name = _standard_name)
			THEN
				 SET _ret = 1;
                 set _standardval = false;
			END IF;
				
                IF(_standardval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_standard_id = 0 )
              THEN
					Insert into standard_master
					values(null,_standard_name,_standard_insdt,_standard_insip,_standard_insrid,_standard_logdt,_standard_logip,_standard_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_standard_id != 0)
              THEN
					Update standard_master set standard_name=_standard_name,standard_logdt=_standard_logdt,standard_logip=_standard_logip,standard_logrid  =_standard_logrid  where standard_id=_standard_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_state`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_state` (IN `_state_id` INT(11), IN `_state_country_id` INT(11), IN `_state_name` VARCHAR(100), IN `_state_insdt` DATETIME, IN `_state_insrid` INT(11), IN `_state_logdt` DATETIME, IN `_state_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT state_id FROM state_master WHERE state_name=_state_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_state_id = 0 )
              THEN
						INSERT INTO state_master VALUES(NULL,_state_country_id , _state_name,_state_insdt,_state_insrid,_state_logdt,_state_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_state_id != 0)
              THEN
					UPDATE state_master SET state_country_id=_state_country_id , state_name=_state_name ,  state_logdt=_state_logdt , state_logrid=_state_logrid where state_id=_state_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `add_update_subject_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_subject_master` (IN `_subject_id` INT(11), IN `_subject_name` VARCHAR(45), IN `_subject_image` LONGTEXT, IN `_subject_insdt` DATETIME, IN `_subject_insip` VARCHAR(45), IN `_subject_insrid` INT(11), IN `_subject_logdt` DATETIME, IN `_subject_logip` VARCHAR(45), IN `_subject_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _subjectval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _subjectval = true;
			            
			IF EXISTS(SELECT subject_id FROM subject_master WHERE subject_name = _subject_name)
			THEN
				 SET _ret = 1;
                 set _subjectval = false;
			END IF;
				
                IF(_subjectval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_subject_id = 0 )
              THEN
					Insert into subject_master
					values(null,_subject_name,_subject_image,_subject_insdt,_subject_insip,_subject_insrid,_subject_logdt,_subject_logip,_subject_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
             
		END IF;  IF(_subject_id != 0)
              THEN
					Update subject_master set subject_name=_subject_name,subject_image=_subject_image,subject_logdt=_subject_logdt,subject_logip=_subject_logip,subject_logrid  =_subject_logrid  where subject_id=_subject_id;
					SET _ret = 3;
				END IF;
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_sub_topic_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_sub_topic_master` (IN `_sub_topic_id` INT(11), IN `_sub_topic_topic_id` VARCHAR(45), IN `_sub_topic_name` VARCHAR(45), IN `_sub_topic_insdt` DATETIME, IN `_sub_topic_insip` VARCHAR(45), IN `_sub_topic_insrid` INT(11), IN `_sub_topic_logdt` DATETIME, IN `_sub_topic_logip` VARCHAR(45), IN `_sub_topic_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _subtopicval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _subtopicval = true;
			            
			IF EXISTS(SELECT sub_topic_id FROM sub_topic_master WHERE sub_topic_topic_id=_sub_topic_topic_id and sub_topic_name=_sub_topic_name)
			THEN
				 SET _ret = 1;
                 set _subtopicval = false;
			END IF;
				
                IF(_subtopicval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_sub_topic_id = 0 )
              THEN
					Insert into sub_topic_master
					values(null,_sub_topic_topic_id,_sub_topic_name,_sub_topic_insdt,_sub_topic_insip,_sub_topic_insrid,_sub_topic_logdt,_sub_topic_logip,_sub_topic_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_sub_topic_id != 0)
              THEN
					Update sub_topic_master set sub_topic_topic_id=_sub_topic_topic_id,sub_topic_name=_sub_topic_name,sub_topic_logdt=_sub_topic_logdt,sub_topic_logip=_sub_topic_logip,sub_topic_logrid=_sub_topic_logrid where sub_topic_id=_sub_topic_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_taluka`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_taluka` (IN `_taluka_id` INT(11), IN `_taluka_distric_id` INT(11), IN `_taluka_name` VARCHAR(100), IN `_taluka_insdt` DATETIME, IN `_taluka_insrid` INT(11), IN `_taluka_logdt` DATETIME, IN `_taluka_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
				IF EXISTS(SELECT taluka_id FROM taluka_master WHERE taluka_name=_taluka_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_taluka_id = 0 )
              THEN
						INSERT INTO taluka_master VALUES(NULL,_taluka_distric_id , _taluka_name,_taluka_insdt,_taluka_insrid,_taluka_logdt,_taluka_logrid);
                    SET _ret = 2;
			   END IF;       
              	
		END IF; 
         IF(_taluka_id != 0)
              THEN
					UPDATE taluka_master SET taluka_distric_id=_taluka_distric_id , taluka_name=_taluka_name ,  taluka_logdt=_taluka_logdt , taluka_logrid=_taluka_logrid where taluka_id=_taluka_id;
					SET _ret = 3;
				END IF;
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `add_update_third_topic`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_third_topic` (IN `_third_topic_id` INT(11), IN `_third_topic_sub_topic_id` INT(11), IN `_third_topic_name` VARCHAR(45), IN `_third_topic_insdt` DATETIME, IN `_third_topic_insip` VARCHAR(45), IN `_third_topic_insrid` INT(11), IN `_third_topic_logdt` DATETIME, IN `_third_topic_logip` VARCHAR(45), IN `_third_topic_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _thirdtopicval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _thirdtopicval = true;
			            
			IF EXISTS(SELECT third_topic_id FROM third_topic_master WHERE third_topic_sub_topic_id=_third_topic_sub_topic_id and third_topic_name=_third_topic_name)
			THEN
				 SET _ret = 1;
                 set _thirdtopicval = false;
			END IF;
				
                IF(_thirdtopicval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_third_topic_id = 0 )
              THEN
					Insert into third_topic_master
					values(null,_third_topic_sub_topic_id,_third_topic_name,_third_topic_insdt,_third_topic_insip,_third_topic_insrid,_third_topic_logdt,_third_topic_logip,_third_topic_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_third_topic_id != 0)
              THEN
					Update third_topic_master set third_topic_sub_topic_id=_third_topic_sub_topic_id,third_topic_name=_third_topic_name,third_topic_logdt=_third_topic_logdt,third_topic_logip=_third_topic_logip,third_topic_logrid=_third_topic_logrid where third_topic_id=_third_topic_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `add_update_topic_master`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_update_topic_master` (IN `_topic_id` INT(11), IN `_topic_subject_id` INT(11), IN `_topic_name` VARCHAR(45), IN `_topic_insdt` DATETIME, IN `_topic_insip` VARCHAR(45), IN `_topic_insrid` INT(11), IN `_topic_logdt` DATETIME, IN `_topic_logip` VARCHAR(45), IN `_topic_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _topicval bool;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;
    START TRANSACTION;
    SET _topicval = true;
			            
			IF EXISTS(SELECT topic_id FROM topic_master WHERE topic_subject_id=_topic_subject_id and topic_name = _topic_name)
			THEN
				 SET _ret = 1;
                 set _topicval = false;
			END IF;
				
                IF(_topicval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_topic_id = 0 )
              THEN
					Insert into topic_master
					values(null,_topic_subject_id,_topic_name,_topic_insdt,_topic_insip,_topic_insrid,_topic_logdt,_topic_logip,_topic_logrid);
					SET _ret = 2;
			   END IF;       
              	
                
              IF(_topic_id != 0)
              THEN
					Update topic_master set topic_subject_id=_topic_subject_id,topic_name=_topic_name,topic_logdt=_topic_logdt,topic_logip=_topic_logip,topic_logrid  =_topic_logrid  where topic_id=_topic_id;
					SET _ret = 3;
				END IF;
		END IF; 
           
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `admin_user_login`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_user_login` (IN `_aum_contactno` VARCHAR(45), IN `_aum_password` VARCHAR(45), OUT `_ret` TINYINT(2), OUT `_admin_user_id` INT(11), OUT `_admin_user_role` INT(11))  BEGIN
   
	
    set _ret=0;
    set _admin_user_id=0;
    set _admin_user_role=0;
    
	if exists(select aum_id from admin_user_master where aum_contactno=_aum_contactno and aum_password=_aum_password)
	then 
        
			if exists
			(select aum_id from admin_user_master where aum_contactno=_aum_contactno and aum_password=_aum_password and aum_status=1)
				then
                
					
					set _admin_user_id = (select aum_id from admin_user_master where aum_contactno=_aum_contactno and aum_password=_aum_password);
					set _admin_user_role = (select aum_user_role from admin_user_master where aum_id=_admin_user_id);
					set _ret=1;
			UPDATE admin_user_master SET aum_last_login = NOW() WHERE aum_id = _admin_user_id; 
				set _ret=2;
              
						else 
						set _ret=1;
						set _admin_user_id=0;
						set _admin_user_role=-1;
			end if;
    else
    
		set _ret=0;
        set _admin_user_id=0;
        set _admin_user_role=-1;
    end if;
END$$

DROP PROCEDURE IF EXISTS `institute_details_add_update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `institute_details_add_update` (IN `_id_id` INT(11), IN `_id_institute_code` VARCHAR(45), IN `_id_type` INT(11), IN `_id_name` VARCHAR(45), IN `_id_mobile_no` VARCHAR(12), IN `_id_email` VARCHAR(45), IN `_id_email_verification` VARCHAR(45), IN `_id_website` VARCHAR(45), IN `_id_website_verification` VARCHAR(45), IN `_id_address_line_1` VARCHAR(45), IN `_id_address_line_2` VARCHAR(45), IN `_id_landmark` VARCHAR(45), IN `_id_state_id` INT(11), IN `_id_district_id` INT(11), IN `_id_tahesil_id` INT(11), IN `_id_password` VARCHAR(45), IN `_id_verification_status` VARCHAR(45), IN `_id_date_of_registration` DATETIME, IN `_id_logdt` DATETIME, IN `_id_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT id_id FROM institute_details WHERE id_mobile_no=_id_mobile_no)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_id_id = 0 )
              THEN
						INSERT INTO institute_details VALUES(NULL,_id_institute_code,_id_type,_id_name,_id_mobile_no,_id_email,_id_email_verification,_id_website,_id_website_verification,_id_address_line_1,_id_address_line_2,_id_landmark,_id_state_id,_id_district_id,_id_tahesil_id,_id_password,_id_verification_status,_id_date_of_registration,_id_logdt,_id_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
       /*  IF(_country_id != 0)
              THEN
					UPDATE institute_details SET country_name=_country_name ,  country_logdt=_country_logdt , country_logrid=_country_logrid where country_id=_country_id;
					SET _ret = 3;
				END IF;*/
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `institute_type_add_update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `institute_type_add_update` (IN `_institute_type_id` INT(11), IN `_institute_type_name` VARCHAR(45), IN `_institute_type_insdt` DATETIME, IN `_institute_type_insip` VARCHAR(45), IN `_institute_type_insrid` INT(11), IN `_institute_type_logdt` DATETIME, IN `_institute_type_logip` VARCHAR(45), IN `_institute_type_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT institute_type_id FROM institute_type_master WHERE institute_type_name=_institute_type_name)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_institute_type_id = 0 )
              THEN
						INSERT INTO institute_type_master VALUES(NULL,_institute_type_name,_institute_type_insdt,_institute_type_insip,_institute_type_insrid,_institute_type_logdt,_institute_type_logip,_institute_type_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_institute_type_id != 0)
              THEN
					UPDATE institute_type_master SET institute_type_name=_institute_type_name ,  institute_type_logdt=_institute_type_logdt ,institute_type_logip=_institute_type_logip , institute_type_logrid=_institute_type_logrid where institute_type_id=_institute_type_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `notice_master_add_update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `notice_master_add_update` (IN `_nm_id` INT(11), IN `_nm_institute_id` INT(11), IN `_nm_title` VARCHAR(45), IN `_nm_description` LONGTEXT, IN `_nm_file_upload` LONGTEXT, IN `_nm_effective_date` DATETIME, IN `_nm_ineffective_date` DATETIME, IN `_nm_status` VARCHAR(45), IN `_nm_insdt` DATETIME, IN `_nm_insrid` INT(11), IN `_nm_logdt` DATETIME, IN `_nm_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			/*IF EXISTS(SELECT nm_id FROM notice_master WHERE nm_title=_nm_title)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;*/
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_nm_id = 0 )
              THEN
						INSERT INTO notice_master VALUES(NULL,_nm_institute_id,_nm_title,_nm_description,_nm_file_upload,_nm_effective_date,_nm_ineffective_date,_nm_status,_nm_insdt,_nm_insrid,_nm_logdt,_nm_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_nm_id != 0)
              THEN
					UPDATE notice_master SET nm_title=_nm_title,nm_description=_nm_description,nm_file_upload=_nm_file_upload,nm_effective_date=_nm_effective_date,nm_ineffective_date=_nm_ineffective_date,nm_logdt=_nm_logdt,nm_logrid=_nm_logrid where nm_id=_nm_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `student_institute_link_add`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `student_institute_link_add` (IN `_institute_code_no` VARCHAR(45), IN `_sil_id` INT(11), IN `_sil_id_id` VARCHAR(45), IN `_sil_stud_id` INT(11), IN `_sil_verification_status` VARCHAR(45), OUT `_ret` TINYINT(2))  BEGIN
declare _mobileval bool;
declare _refval bool;


    START TRANSACTION;
    SET _mobileval = true;
		
           if(_mobileval=true)
			then
				if(_institute_code_no != '0')
				then
					IF EXISTS(SELECT id_id FROM institute_details WHERE id_mobile_no=_institute_code_no)
						then
							set _sil_id_id=(SELECT id_id FROM institute_details WHERE id_mobile_no=_institute_code_no);
						    set	_refval=true;
                            IF EXISTS(SELECT sil_id FROM student_institute_link WHERE sil_id_id=_sil_id_id and sil_stud_id=_sil_stud_id)
								THEN
									SET _ret = 0;
									set _mobileval = false;

							else
						insert into student_institute_link values(Null,_sil_id_id,_sil_stud_id,_sil_verification_status);
						set _ret=_sil_id_id;
                        END IF;
                    else 
						set _refval=false;
						set _ret=-1;
				end if;
                end if;
           end if;
               
COMMIT;
END$$

DROP PROCEDURE IF EXISTS `student_master_add_update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `student_master_add_update` (IN `_stud_id` INT(11), IN `_stud_first_name` VARCHAR(45), IN `_stud_middle_name` VARCHAR(45), IN `_stud_last_name` VARCHAR(45), IN `_stud_gender` VARCHAR(45), IN `_stud_mobile_no` VARCHAR(12), IN `_stud_dob` DATETIME, IN `_stud_email` VARCHAR(45), IN `_stud_std_id` INT(11), IN `_stud_password` VARCHAR(45), IN `_stud_status` VARCHAR(45), IN `_stud_insdt` DATETIME, IN `_stud_insip` VARCHAR(25), IN `_stud_insrid` INT(11), IN `_stud_logdt` DATETIME, IN `_stud_logip` VARCHAR(25), IN `_stud_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT stud_id FROM student_details WHERE stud_mobile_no=_stud_mobile_no)
			THEN
				 SET _ret = 0;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 0;
                ELSE
              IF(_stud_id = 0 )
              THEN
						INSERT INTO student_details VALUES(NULL,_stud_first_name,_stud_middle_name,_stud_last_name,_stud_gender,_stud_mobile_no,_stud_dob,_stud_email,_stud_std_id,_stud_password,_stud_status,_stud_insdt,_stud_insip,_stud_insrid,_stud_logdt,_stud_logip,_stud_logrid);
                    SET _ret = last_insert_id();
			   END IF;       
              	
                
             
		END IF; 
         IF(_stud_id != 0)
              THEN
					UPDATE student_details SET stud_first_name=_stud_first_name,stud_middle_name=_stud_middle_name,stud_last_name=_stud_last_name,stud_gender=_stud_gender,stud_mobile_no=_stud_mobile_no,stud_dob=_stud_dob,stud_email=_stud_email,stud_std_id=_stud_std_id,stud_logdt=_stud_logdt,stud_logip=_stud_logip,stud_logrid=_stud_logrid where stud_id=_stud_id;
					SET _ret = -1;
				END IF;
           
COMMIT;

END$$

DROP PROCEDURE IF EXISTS `video_master_add_Update`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `video_master_add_Update` (IN `_video_id` INT(11), IN `_video_institute_id` INT(11), IN `_video_standard_id` INT(11), IN `_video_third_topic_id` INT(11), IN `_video_medium_id` INT(11), IN `_video_board_id` INT(11), IN `_video_language_id` INT(11), IN `_video_link` LONGTEXT, IN `_video_title` MEDIUMTEXT, IN `_video_description` LONGTEXT, IN `_video_meta_tag` LONGTEXT, IN `_video_thumbnail_image` VARCHAR(45), IN `_video_insdt` DATETIME, IN `_video_insip` VARCHAR(45), IN `_video_insrid` INT(11), IN `_video_logdt` DATETIME, IN `_video_logip` VARCHAR(45), IN `_video_logrid` INT(11), OUT `_ret` TINYINT(2))  BEGIN
declare _desval bool;
	/*DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
	BEGIN
		SET _ret = 0;
        
		ROLLBACK;
	END;*/
    START TRANSACTION;
    SET _desval = true;
			            
			IF EXISTS(SELECT video_id FROM video_master WHERE video_title=_video_title)
			THEN
				 SET _ret = 1;
                 set _desval = false;
			END IF;
				
                IF(_desval = false)
                THEN
					SET _ret = 1;
                ELSE
              IF(_video_id = 0 )
              THEN
						INSERT INTO video_master VALUES(NULL,_video_institute_id,_video_standard_id,_video_third_topic_id,_video_medium_id,_video_board_id,_video_language_id,_video_link,_video_title,_video_description,_video_meta_tag,_video_thumbnail_image,_video_insdt,_video_insip,_video_insrid,_video_logdt,_video_logip,_video_logrid);
                    SET _ret = 2;
			   END IF;       
              	
                
             
		END IF; 
         IF(_video_id != 0)
              THEN
					UPDATE video_master SET video_institute_id=_video_institute_id,video_standard_id=_video_standard_id,video_third_topic_id=_video_third_topic_id,video_medium_id=_video_medium_id,video_board_id=_video_board_id,video_language_id=_video_language_id,video_link=_video_link,video_title=_video_title,video_description=_video_description,video_meta_tag=_video_meta_tag,video_logdt=_video_logdt,video_thumbnail_image=_video_thumbnail_image,video_logip=_video_logip,video_logrid=_video_logrid where video_id=_video_id;
					SET _ret = 3;
				END IF;
           
COMMIT;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_user_master`
--

DROP TABLE IF EXISTS `admin_user_master`;
CREATE TABLE IF NOT EXISTS `admin_user_master` (
  `aum_id` int(11) NOT NULL AUTO_INCREMENT,
  `aum_fullname` varchar(45) DEFAULT NULL,
  `aum_gender` varchar(45) DEFAULT NULL,
  `aum_contactno` varchar(45) DEFAULT NULL,
  `aum_email` varchar(45) DEFAULT NULL,
  `aum_password` varchar(45) DEFAULT NULL,
  `aum_user_role` int(11) DEFAULT NULL,
  `aum_status` tinyint(2) DEFAULT NULL,
  `aum_insdt` datetime DEFAULT NULL,
  `aum_insrid` int(11) DEFAULT NULL,
  `aum_logdt` datetime DEFAULT NULL,
  `aum_logrid` int(11) DEFAULT NULL,
  `aum_last_login` datetime DEFAULT NULL,
  `aum_last_logout` datetime DEFAULT NULL,
  PRIMARY KEY (`aum_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin_user_master`
--

INSERT INTO `admin_user_master` (`aum_id`, `aum_fullname`, `aum_gender`, `aum_contactno`, `aum_email`, `aum_password`, `aum_user_role`, `aum_status`, `aum_insdt`, `aum_insrid`, `aum_logdt`, `aum_logrid`, `aum_last_login`, `aum_last_logout`) VALUES
(1, 'Akash', 'Male', '9876543210', 'akashchauhan@gmail.com', '1234', 1, 1, '2019-10-10 00:00:00', 1, '2019-10-10 00:00:00', 1, '2020-01-20 16:17:10', '2019-10-10 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `board_master`
--

DROP TABLE IF EXISTS `board_master`;
CREATE TABLE IF NOT EXISTS `board_master` (
  `board_id` int(11) NOT NULL AUTO_INCREMENT,
  `board_name` varchar(45) DEFAULT NULL,
  `board_insdt` datetime DEFAULT NULL,
  `board_insip` varchar(45) DEFAULT NULL,
  `board_insrid` int(11) DEFAULT NULL,
  `board_logdt` datetime DEFAULT NULL,
  `board_logip` varchar(45) DEFAULT NULL,
  `board_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`board_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `board_master`
--

INSERT INTO `board_master` (`board_id`, `board_name`, `board_insdt`, `board_insip`, `board_insrid`, `board_logdt`, `board_logip`, `board_logrid`) VALUES
(1, 'GSEB', '2019-10-09 21:19:22', '1', 1, '2019-10-09 21:19:32', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `country_master`
--

DROP TABLE IF EXISTS `country_master`;
CREATE TABLE IF NOT EXISTS `country_master` (
  `country_id` int(11) NOT NULL AUTO_INCREMENT,
  `country_name` varchar(100) NOT NULL,
  `country_insdt` datetime NOT NULL,
  `country_insrid` int(11) NOT NULL,
  `country_logdt` datetime NOT NULL,
  `country_logrid` int(11) NOT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `country_master`
--

INSERT INTO `country_master` (`country_id`, `country_name`, `country_insdt`, `country_insrid`, `country_logdt`, `country_logrid`) VALUES
(1, 'INDIA', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(2, 'US', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(3, 'UK', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `country_state_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `country_state_view`;
CREATE TABLE IF NOT EXISTS `country_state_view` (
`country_id` int(11)
,`country_name` varchar(100)
,`country_insdt` datetime
,`country_insrid` int(11)
,`country_logdt` datetime
,`country_logrid` int(11)
,`state_id` int(11)
,`state_country_id` int(11)
,`state_name` varchar(100)
,`state_insdt` datetime
,`state_insrid` int(11)
,`state_logdt` datetime
,`state_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `distric_master`
--

DROP TABLE IF EXISTS `distric_master`;
CREATE TABLE IF NOT EXISTS `distric_master` (
  `distric_id` int(11) NOT NULL AUTO_INCREMENT,
  `distric_state_id` int(11) NOT NULL,
  `distric_name` varchar(100) NOT NULL,
  `distric_insdt` datetime NOT NULL,
  `distric_insrid` int(11) NOT NULL,
  `distric_logdt` datetime NOT NULL,
  `distric_logrid` int(11) NOT NULL,
  PRIMARY KEY (`distric_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `distric_master`
--

INSERT INTO `distric_master` (`distric_id`, `distric_state_id`, `distric_name`, `distric_insdt`, `distric_insrid`, `distric_logdt`, `distric_logrid`) VALUES
(1, 1, 'SK', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(2, 2, 'HSKIDH', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(3, 3, 'UNKLIKS', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `distric_taluka_data_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `distric_taluka_data_view`;
CREATE TABLE IF NOT EXISTS `distric_taluka_data_view` (
`distric_id` int(11)
,`distric_state_id` int(11)
,`distric_name` varchar(100)
,`distric_insdt` datetime
,`distric_insrid` int(11)
,`distric_logdt` datetime
,`distric_logrid` int(11)
,`taluka_id` int(11)
,`taluka_distric_id` int(11)
,`taluka_name` varchar(100)
,`taluka_insdt` datetime
,`taluka_insrid` int(11)
,`taluka_logdt` datetime
,`taluka_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_sub_topic_details`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `get_sub_topic_details`;
CREATE TABLE IF NOT EXISTS `get_sub_topic_details` (
`sub_topic_id` int(11)
,`sub_topic_topic_id` varchar(45)
,`sub_topic_name` varchar(45)
,`sub_topic_insdt` datetime
,`sub_topic_insip` varchar(45)
,`sub_topic_insrid` int(11)
,`sub_topic_logdt` datetime
,`sub_topic_logip` varchar(45)
,`sub_topic_logrid` int(11)
,`topic_id` int(11)
,`topic_subject_id` int(11)
,`topic_name` varchar(45)
,`topic_insdt` datetime
,`topic_insip` varchar(45)
,`topic_insrid` int(11)
,`topic_logdt` datetime
,`topic_logip` varchar(45)
,`topic_logrid` int(11)
,`subject_id` int(11)
,`subject_name` varchar(45)
,`subject_image` longtext
,`subject_insdt` datetime
,`subject_insip` varchar(45)
,`subject_insrid` int(11)
,`subject_logdt` datetime
,`subject_logip` varchar(45)
,`subject_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_third_topic_details`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `get_third_topic_details`;
CREATE TABLE IF NOT EXISTS `get_third_topic_details` (
`third_topic_id` int(11)
,`third_topic_sub_topic_id` int(11)
,`third_topic_name` varchar(45)
,`third_topic_insdt` datetime
,`third_topic_insip` varchar(45)
,`third_topic_insrid` int(11)
,`third_topic_logdt` datetime
,`third_topic_logip` varchar(45)
,`third_topic_logrid` int(11)
,`sub_topic_id` int(11)
,`sub_topic_topic_id` varchar(45)
,`sub_topic_name` varchar(45)
,`sub_topic_insdt` datetime
,`sub_topic_insip` varchar(45)
,`sub_topic_insrid` int(11)
,`sub_topic_logdt` datetime
,`sub_topic_logip` varchar(45)
,`sub_topic_logrid` int(11)
,`topic_id` int(11)
,`topic_subject_id` int(11)
,`topic_name` varchar(45)
,`topic_insdt` datetime
,`topic_insip` varchar(45)
,`topic_insrid` int(11)
,`topic_logdt` datetime
,`topic_logip` varchar(45)
,`topic_logrid` int(11)
,`subject_id` int(11)
,`subject_name` varchar(45)
,`subject_image` longtext
,`subject_insdt` datetime
,`subject_insip` varchar(45)
,`subject_insrid` int(11)
,`subject_logdt` datetime
,`subject_logip` varchar(45)
,`subject_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_topic_details`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `get_topic_details`;
CREATE TABLE IF NOT EXISTS `get_topic_details` (
`topic_id` int(11)
,`topic_subject_id` int(11)
,`topic_name` varchar(45)
,`topic_insdt` datetime
,`topic_insip` varchar(45)
,`topic_insrid` int(11)
,`topic_logdt` datetime
,`topic_logip` varchar(45)
,`topic_logrid` int(11)
,`subject_id` int(11)
,`subject_name` varchar(45)
,`subject_image` longtext
,`subject_insdt` datetime
,`subject_insip` varchar(45)
,`subject_insrid` int(11)
,`subject_logdt` datetime
,`subject_logip` varchar(45)
,`subject_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `institute_and_institute_link_studant_data_fill_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `institute_and_institute_link_studant_data_fill_view`;
CREATE TABLE IF NOT EXISTS `institute_and_institute_link_studant_data_fill_view` (
`sil_id` int(11)
,`sil_id_id` varchar(45)
,`sil_stud_id` int(11)
,`sil_verification_status` varchar(45)
,`id_id` int(11)
,`id_institute_code` varchar(45)
,`id_type` int(11)
,`id_name` varchar(45)
,`id_mobile_no` varchar(12)
,`id_email` varchar(45)
,`id_email_verification` varchar(45)
,`id_website` varchar(100)
,`id_website_verification` varchar(45)
,`id_address_line_1` varchar(45)
,`id_address_line_2` varchar(45)
,`id_landmark` varchar(45)
,`id_state_id` int(11)
,`id_district_id` int(11)
,`id_tahesil_id` int(11)
,`id_password` varchar(45)
,`id_verification_status` varchar(45)
,`id_date_of_registration` datetime
,`id_logdt` datetime
,`id_logrid` int(11)
,`stud_id` int(11)
,`stud_first_name` varchar(45)
,`stud_middle_name` varchar(45)
,`stud_last_name` varchar(45)
,`stud_gender` varchar(45)
,`stud_mobile_no` varchar(12)
,`stud_dob` datetime
,`stud_email` varchar(45)
,`stud_std_id` int(11)
,`stud_password` varchar(45)
,`stud_status` varchar(45)
,`stud_insdt` datetime
,`stud_insip` varchar(25)
,`stud_insrid` int(11)
,`stud_logdt` datetime
,`stud_logip` varchar(25)
,`stud_logrid` int(11)
,`standard_id` int(11)
,`standard_name` varchar(45)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `institute_and_institute_type_data_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `institute_and_institute_type_data_view`;
CREATE TABLE IF NOT EXISTS `institute_and_institute_type_data_view` (
`id_id` int(11)
,`id_institute_code` varchar(45)
,`id_type` int(11)
,`id_name` varchar(45)
,`id_mobile_no` varchar(12)
,`id_email` varchar(45)
,`id_email_verification` varchar(45)
,`id_website` varchar(100)
,`id_website_verification` varchar(45)
,`id_address_line_1` varchar(45)
,`id_address_line_2` varchar(45)
,`id_landmark` varchar(45)
,`id_state_id` int(11)
,`id_district_id` int(11)
,`id_tahesil_id` int(11)
,`id_password` varchar(45)
,`id_verification_status` varchar(45)
,`id_date_of_registration` datetime
,`id_logdt` datetime
,`id_logrid` int(11)
,`institute_type_id` int(11)
,`institute_type_name` varchar(45)
,`institute_type_insdt` datetime
,`institute_type_insip` varchar(45)
,`institute_type_insrid` int(11)
,`institute_type_logdt` datetime
,`institute_type_logip` varchar(45)
,`institute_type_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `institute_details`
--

DROP TABLE IF EXISTS `institute_details`;
CREATE TABLE IF NOT EXISTS `institute_details` (
  `id_id` int(11) NOT NULL AUTO_INCREMENT,
  `id_institute_code` varchar(45) DEFAULT NULL,
  `id_type` int(11) DEFAULT NULL,
  `id_name` varchar(45) DEFAULT NULL,
  `id_mobile_no` varchar(12) DEFAULT NULL,
  `id_email` varchar(45) DEFAULT NULL,
  `id_email_verification` varchar(45) DEFAULT NULL,
  `id_website` varchar(100) DEFAULT NULL,
  `id_website_verification` varchar(45) DEFAULT NULL,
  `id_address_line_1` varchar(45) DEFAULT NULL,
  `id_address_line_2` varchar(45) DEFAULT NULL,
  `id_landmark` varchar(45) DEFAULT NULL,
  `id_state_id` int(11) DEFAULT NULL,
  `id_district_id` int(11) DEFAULT NULL,
  `id_tahesil_id` int(11) DEFAULT NULL,
  `id_password` varchar(45) DEFAULT NULL,
  `id_verification_status` varchar(45) DEFAULT NULL,
  `id_date_of_registration` datetime DEFAULT NULL,
  `id_logdt` datetime DEFAULT NULL,
  `id_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `institute_details`
--

INSERT INTO `institute_details` (`id_id`, `id_institute_code`, `id_type`, `id_name`, `id_mobile_no`, `id_email`, `id_email_verification`, `id_website`, `id_website_verification`, `id_address_line_1`, `id_address_line_2`, `id_landmark`, `id_state_id`, `id_district_id`, `id_tahesil_id`, `id_password`, `id_verification_status`, `id_date_of_registration`, `id_logdt`, `id_logrid`) VALUES
(1, '9898', 3, 'grow more', '0000000000', 'growmore9898@gmail.com', '0', 'www.siddhiclasses.com', '0', 'hparabada', 'agyol road', 'mahet road', 1, 1, 1, '12345678', '1', '2019-11-25 12:03:17', '2019-11-25 12:03:17', 1),
(2, '9898', 5, 'xyz', '1111111111', 'xyz.com', '0', 'fafa.com', '0', 'ajajkaj', '', 'sddd', 1, 1, 1, '12345678', '1', '2019-11-26 14:16:02', '2019-11-26 14:16:02', 1),
(3, '9898', 2, 'grow more', '9999999999', 'fafn@gmail.com', '0', 'fafa.com', '0', 'lll', 'dddd', 'kk', 1, 1, 1, '12345678', '0', '2020-01-20 13:59:28', '2020-01-20 13:59:28', 1);

-- --------------------------------------------------------

--
-- Table structure for table `institute_type_master`
--

DROP TABLE IF EXISTS `institute_type_master`;
CREATE TABLE IF NOT EXISTS `institute_type_master` (
  `institute_type_id` int(11) NOT NULL AUTO_INCREMENT,
  `institute_type_name` varchar(45) DEFAULT NULL,
  `institute_type_insdt` datetime DEFAULT NULL,
  `institute_type_insip` varchar(45) DEFAULT NULL,
  `institute_type_insrid` int(11) DEFAULT NULL,
  `institute_type_logdt` datetime DEFAULT NULL,
  `institute_type_logip` varchar(45) DEFAULT NULL,
  `institute_type_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`institute_type_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `institute_type_master`
--

INSERT INTO `institute_type_master` (`institute_type_id`, `institute_type_name`, `institute_type_insdt`, `institute_type_insip`, `institute_type_insrid`, `institute_type_logdt`, `institute_type_logip`, `institute_type_logrid`) VALUES
(1, 'ip', '2019-10-19 10:54:50', '1', 1, '2019-10-19 10:54:50', '1', 1),
(2, 'grow more', '2019-10-19 10:58:34', '1', 1, '2019-10-19 10:58:34', '1', 1),
(3, 'demo', '2019-10-19 11:00:19', '1', 1, '2019-10-19 11:00:19', '1', 1),
(4, 'vidhay', '2019-10-19 11:01:34', '1', 1, '2019-10-19 11:14:37', '1', 1),
(5, 'demo222', '2019-11-26 14:10:27', '1', 1, '2019-11-26 14:10:27', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `language_master`
--

DROP TABLE IF EXISTS `language_master`;
CREATE TABLE IF NOT EXISTS `language_master` (
  `language_id` int(11) NOT NULL AUTO_INCREMENT,
  `language_name` varchar(45) DEFAULT NULL,
  `language_insdt` datetime DEFAULT NULL,
  `language_insip` varchar(45) DEFAULT NULL,
  `language_insrid` int(11) DEFAULT NULL,
  `language_logdt` datetime DEFAULT NULL,
  `language_logip` varchar(45) DEFAULT NULL,
  `language_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`language_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `language_master`
--

INSERT INTO `language_master` (`language_id`, `language_name`, `language_insdt`, `language_insip`, `language_insrid`, `language_logdt`, `language_logip`, `language_logrid`) VALUES
(1, 'HINDI', '2019-10-19 13:41:13', '1', 1, '2019-10-19 13:41:13', '1', 1),
(2, 'ENGLISH', '2019-10-19 13:42:34', '1', 1, '2019-10-19 13:42:34', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `medium_master`
--

DROP TABLE IF EXISTS `medium_master`;
CREATE TABLE IF NOT EXISTS `medium_master` (
  `medium_id` int(11) NOT NULL AUTO_INCREMENT,
  `medium_name` varchar(45) DEFAULT NULL,
  `medium_insdt` datetime DEFAULT NULL,
  `medium_insip` varchar(45) DEFAULT NULL,
  `medium_insrid` int(11) DEFAULT NULL,
  `medium_logdt` datetime DEFAULT NULL,
  `medium_logip` varchar(45) DEFAULT NULL,
  `medium_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`medium_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `medium_master`
--

INSERT INTO `medium_master` (`medium_id`, `medium_name`, `medium_insdt`, `medium_insip`, `medium_insrid`, `medium_logdt`, `medium_logip`, `medium_logrid`) VALUES
(1, 'HINDI', '2019-10-09 21:08:35', '1', 1, '2019-10-09 21:08:41', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notice_master`
--

DROP TABLE IF EXISTS `notice_master`;
CREATE TABLE IF NOT EXISTS `notice_master` (
  `nm_id` int(11) NOT NULL AUTO_INCREMENT,
  `nm_institute_id` int(11) DEFAULT NULL,
  `nm_title` varchar(45) DEFAULT NULL,
  `nm_description` longtext,
  `nm_file_upload` longtext,
  `nm_effective_date` datetime DEFAULT NULL,
  `nm_ineffective_date` datetime DEFAULT NULL,
  `nm_status` varchar(45) DEFAULT NULL,
  `nm_insdt` datetime DEFAULT NULL,
  `nm_insrid` int(11) DEFAULT NULL,
  `nm_logdt` datetime DEFAULT NULL,
  `nm_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`nm_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `notice_master`
--

INSERT INTO `notice_master` (`nm_id`, `nm_institute_id`, `nm_title`, `nm_description`, `nm_file_upload`, `nm_effective_date`, `nm_ineffective_date`, `nm_status`, `nm_insdt`, `nm_insrid`, `nm_logdt`, `nm_logrid`) VALUES
(1, 1, 'to day is hollyday', 'gopaaysda jfwnefal af ajenql', '~/institute/noticeimg/not2.PNG', '2019-11-08 00:00:00', '2019-11-08 00:00:00', '0', '2019-11-25 14:29:40', 1, '2019-11-25 14:29:40', 1),
(2, 2, 'to day is hollyday', 'gopaaysda jfwnefal af ajenql', '~/institute/noticeimg/Hotel.jpg', '2019-11-08 00:00:00', '2019-11-10 00:00:00', '0', '2019-11-26 14:38:24', 2, '2019-11-26 14:38:24', 2),
(3, 1, 'jfkajkj', 'jfklakj', '', '2020-01-09 00:00:00', '2020-01-11 00:00:00', '0', '2020-01-10 14:47:55', 1, '2020-01-10 14:47:55', 1),
(4, 1, 'to day is hollyday', 'kfl', '~/institute/noticeimg/1d8579cf-7f5e-4b86-a8e4-01acde22512f.jpg', '2020-01-11 00:00:00', '2020-01-15 00:00:00', '0', '2020-01-10 15:37:14', 1, '2020-01-10 15:37:14', 1),
(5, 1, 'fq;knkn', 'vlqknkn', '~/institute/noticeimg/490a8fcd-98d9-43cb-aeac-74804ca8281e.jpg', '2020-01-11 00:00:00', '2020-01-25 00:00:00', '0', '2020-01-10 15:38:08', 1, '2020-01-10 15:38:08', 1);

-- --------------------------------------------------------

--
-- Table structure for table `standard_master`
--

DROP TABLE IF EXISTS `standard_master`;
CREATE TABLE IF NOT EXISTS `standard_master` (
  `standard_id` int(11) NOT NULL AUTO_INCREMENT,
  `standard_name` varchar(45) DEFAULT NULL,
  `standard_insdt` datetime DEFAULT NULL,
  `standard_insip` varchar(45) DEFAULT NULL,
  `standard_insrid` int(11) DEFAULT NULL,
  `standard_logdt` datetime DEFAULT NULL,
  `standard_logip` varchar(45) DEFAULT NULL,
  `standard_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`standard_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `standard_master`
--

INSERT INTO `standard_master` (`standard_id`, `standard_name`, `standard_insdt`, `standard_insip`, `standard_insrid`, `standard_logdt`, `standard_logip`, `standard_logrid`) VALUES
(1, 'STD 9', '2019-10-09 20:45:32', '1', 1, '2019-10-09 20:45:36', '1', 1),
(2, 'STD 1', '2019-10-25 14:54:56', '1', 1, '2019-10-25 14:54:56', '1', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `state_and_distric_data_view`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `state_and_distric_data_view`;
CREATE TABLE IF NOT EXISTS `state_and_distric_data_view` (
`state_id` int(11)
,`state_country_id` int(11)
,`state_name` varchar(100)
,`state_insdt` datetime
,`state_insrid` int(11)
,`state_logdt` datetime
,`state_logrid` int(11)
,`distric_id` int(11)
,`distric_state_id` int(11)
,`distric_name` varchar(100)
,`distric_insdt` datetime
,`distric_insrid` int(11)
,`distric_logdt` datetime
,`distric_logrid` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `state_master`
--

DROP TABLE IF EXISTS `state_master`;
CREATE TABLE IF NOT EXISTS `state_master` (
  `state_id` int(11) NOT NULL AUTO_INCREMENT,
  `state_country_id` int(11) NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `state_insdt` datetime NOT NULL,
  `state_insrid` int(11) NOT NULL,
  `state_logdt` datetime NOT NULL,
  `state_logrid` int(11) NOT NULL,
  PRIMARY KEY (`state_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `state_master`
--

INSERT INTO `state_master` (`state_id`, `state_country_id`, `state_name`, `state_insdt`, `state_insrid`, `state_logdt`, `state_logrid`) VALUES
(1, 1, 'GUJ', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(2, 2, 'HSK', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(3, 3, 'UKIN', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `student_details`
--

DROP TABLE IF EXISTS `student_details`;
CREATE TABLE IF NOT EXISTS `student_details` (
  `stud_id` int(11) NOT NULL AUTO_INCREMENT,
  `stud_first_name` varchar(45) DEFAULT NULL,
  `stud_middle_name` varchar(45) DEFAULT NULL,
  `stud_last_name` varchar(45) DEFAULT NULL,
  `stud_gender` varchar(45) DEFAULT NULL,
  `stud_mobile_no` varchar(12) DEFAULT NULL,
  `stud_dob` datetime DEFAULT NULL,
  `stud_email` varchar(45) DEFAULT NULL,
  `stud_std_id` int(11) DEFAULT NULL,
  `stud_password` varchar(45) DEFAULT NULL,
  `stud_status` varchar(45) DEFAULT NULL,
  `stud_insdt` datetime DEFAULT NULL,
  `stud_insip` varchar(25) DEFAULT NULL,
  `stud_insrid` int(11) DEFAULT NULL,
  `stud_logdt` datetime DEFAULT NULL,
  `stud_logip` varchar(25) DEFAULT NULL,
  `stud_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`stud_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_details`
--

INSERT INTO `student_details` (`stud_id`, `stud_first_name`, `stud_middle_name`, `stud_last_name`, `stud_gender`, `stud_mobile_no`, `stud_dob`, `stud_email`, `stud_std_id`, `stud_password`, `stud_status`, `stud_insdt`, `stud_insip`, `stud_insrid`, `stud_logdt`, `stud_logip`, `stud_logrid`) VALUES
(1, 'akash', 'vi', 'chauhan', 'Male', '5555555555', '2019-11-14 00:00:00', 'aksh9898@gmail.com', 2, '12345678', '0', '2019-11-25 11:58:26', '1', 0, '2019-11-28 18:23:51', '1', 0),
(2, 'xyz', 'z', 'uu', 'Male', '7777777777', '2019-11-14 00:00:00', 'xyz@gmail.com', 1, '12345678', '0', '2019-11-26 14:19:47', '1', 0, '2019-11-26 14:19:47', '1', 0),
(3, 'sknfqnkvnnk', 'nnklqnklnbkln', 'lnknklsnvlkn', 'Male', '8888888888', '2020-01-17 00:00:00', 'himj#gmail.com', 2, '12345678', '0', '2020-01-19 13:27:09', '1', 0, '2020-01-19 13:27:09', '1', 0),
(4, 'fan', 'fnn', 'lk', 'Female', '9999999999', '2020-01-16 00:00:00', 'ak@gmail.com', 2, '12345678', '0', '2020-01-20 14:26:19', '1', 0, '2020-01-20 14:26:19', '1', 0);

-- --------------------------------------------------------

--
-- Table structure for table `student_institute_link`
--

DROP TABLE IF EXISTS `student_institute_link`;
CREATE TABLE IF NOT EXISTS `student_institute_link` (
  `sil_id` int(11) NOT NULL AUTO_INCREMENT,
  `sil_id_id` varchar(45) DEFAULT NULL,
  `sil_stud_id` int(11) DEFAULT NULL,
  `sil_verification_status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`sil_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_institute_link`
--

INSERT INTO `student_institute_link` (`sil_id`, `sil_id_id`, `sil_stud_id`, `sil_verification_status`) VALUES
(1, '1', 1, '1'),
(2, '2', 2, '1'),
(7, '2', 1, '0'),
(8, '1', 3, '0');

-- --------------------------------------------------------

--
-- Table structure for table `student_task_reminder`
--

DROP TABLE IF EXISTS `student_task_reminder`;
CREATE TABLE IF NOT EXISTS `student_task_reminder` (
  `str_id` int(11) NOT NULL AUTO_INCREMENT,
  `str_student_id` int(11) DEFAULT NULL,
  `str_task` varchar(45) DEFAULT NULL,
  `str_status` varchar(45) DEFAULT NULL,
  `str_insdt` datetime DEFAULT NULL,
  `str_insrid` int(11) DEFAULT NULL,
  `str_logdt` datetime DEFAULT NULL,
  `str_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`str_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `student_task_reminder`
--

INSERT INTO `student_task_reminder` (`str_id`, `str_student_id`, `str_task`, `str_status`, `str_insdt`, `str_insrid`, `str_logdt`, `str_logrid`) VALUES
(3, 1, 'xyz', '1', '2020-01-20 14:59:20', 1, '2020-01-20 14:59:20', 1),
(4, 1, 'abc', '0', '2020-01-20 15:00:31', 1, '2020-01-20 15:00:31', 1),
(5, 1, 'opq', '0', '2020-01-20 15:00:42', 1, '2020-01-20 15:00:42', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subject_master`
--

DROP TABLE IF EXISTS `subject_master`;
CREATE TABLE IF NOT EXISTS `subject_master` (
  `subject_id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_name` varchar(45) DEFAULT NULL,
  `subject_image` longtext,
  `subject_insdt` datetime DEFAULT NULL,
  `subject_insip` varchar(45) DEFAULT NULL,
  `subject_insrid` int(11) DEFAULT NULL,
  `subject_logdt` datetime DEFAULT NULL,
  `subject_logip` varchar(45) DEFAULT NULL,
  `subject_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`subject_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `subject_master`
--

INSERT INTO `subject_master` (`subject_id`, `subject_name`, `subject_image`, `subject_insdt`, `subject_insip`, `subject_insrid`, `subject_logdt`, `subject_logip`, `subject_logrid`) VALUES
(1, 'GUJARATI', '~/Admin/subjectimage/not2.PNG', '2019-10-09 20:56:51', '1', 1, '2019-11-25 12:19:14', '1', 1),
(2, 'SCIENCE', '~/Admin/subjectimage/bc5.jpg', '2019-10-23 12:53:18', '1', 1, '2019-10-23 12:53:18', '1', 1),
(3, 'ENGLISH', '~/Admin/subjectimage/bc5.jpg', '2019-10-23 12:53:33', '1', 1, '2019-10-23 12:53:33', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `sub_topic_master`
--

DROP TABLE IF EXISTS `sub_topic_master`;
CREATE TABLE IF NOT EXISTS `sub_topic_master` (
  `sub_topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `sub_topic_topic_id` varchar(45) DEFAULT NULL,
  `sub_topic_name` varchar(45) DEFAULT NULL,
  `sub_topic_insdt` datetime DEFAULT NULL,
  `sub_topic_insip` varchar(45) DEFAULT NULL,
  `sub_topic_insrid` int(11) DEFAULT NULL,
  `sub_topic_logdt` datetime DEFAULT NULL,
  `sub_topic_logip` varchar(45) DEFAULT NULL,
  `sub_topic_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`sub_topic_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sub_topic_master`
--

INSERT INTO `sub_topic_master` (`sub_topic_id`, `sub_topic_topic_id`, `sub_topic_name`, `sub_topic_insdt`, `sub_topic_insip`, `sub_topic_insrid`, `sub_topic_logdt`, `sub_topic_logip`, `sub_topic_logrid`) VALUES
(1, '1', 'SFDSSDF', '2019-10-13 13:49:39', '1', 1, '2019-10-13 14:08:25', '1', 1),
(2, '1', 'XYZ', '2019-10-13 18:05:37', '1', 1, '2019-10-13 18:05:37', '1', 1),
(3, '2', 'ABC', '2019-10-23 13:11:18', '1', 1, '2019-10-23 13:11:18', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `taluka_master`
--

DROP TABLE IF EXISTS `taluka_master`;
CREATE TABLE IF NOT EXISTS `taluka_master` (
  `taluka_id` int(11) NOT NULL AUTO_INCREMENT,
  `taluka_distric_id` int(11) NOT NULL,
  `taluka_name` varchar(100) NOT NULL,
  `taluka_insdt` datetime NOT NULL,
  `taluka_insrid` int(11) NOT NULL,
  `taluka_logdt` datetime NOT NULL,
  `taluka_logrid` int(11) NOT NULL,
  PRIMARY KEY (`taluka_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `taluka_master`
--

INSERT INTO `taluka_master` (`taluka_id`, `taluka_distric_id`, `taluka_name`, `taluka_insdt`, `taluka_insrid`, `taluka_logdt`, `taluka_logrid`) VALUES
(1, 1, 'HIMMATNAGAR', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(2, 2, 'HKISHK', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1),
(3, 3, 'UKIJSHAKI', '2019-10-18 00:00:00', 1, '2019-10-18 00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `third_topic_master`
--

DROP TABLE IF EXISTS `third_topic_master`;
CREATE TABLE IF NOT EXISTS `third_topic_master` (
  `third_topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `third_topic_sub_topic_id` int(11) DEFAULT NULL,
  `third_topic_name` varchar(45) DEFAULT NULL,
  `third_topic_insdt` datetime DEFAULT NULL,
  `third_topic_insip` varchar(45) DEFAULT NULL,
  `third_topic_insrid` int(11) DEFAULT NULL,
  `third_topic_logdt` datetime DEFAULT NULL,
  `third_topic_logip` varchar(45) DEFAULT NULL,
  `third_topic_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`third_topic_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `third_topic_master`
--

INSERT INTO `third_topic_master` (`third_topic_id`, `third_topic_sub_topic_id`, `third_topic_name`, `third_topic_insdt`, `third_topic_insip`, `third_topic_insrid`, `third_topic_logdt`, `third_topic_logip`, `third_topic_logrid`) VALUES
(1, 1, 'DFSAFDS', '2019-10-13 18:35:38', '1', 0, '2019-10-13 18:37:47', '1', 1),
(2, 3, 'JKL', '2019-10-23 13:11:33', '1', 0, '2019-10-23 13:11:33', '1', 1),
(3, 2, 'akash', '2019-10-23 13:11:33', '1', 0, '2019-10-23 13:11:33', '1', 1);

-- --------------------------------------------------------

--
-- Table structure for table `topic_master`
--

DROP TABLE IF EXISTS `topic_master`;
CREATE TABLE IF NOT EXISTS `topic_master` (
  `topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_subject_id` int(11) DEFAULT NULL,
  `topic_name` varchar(45) DEFAULT NULL,
  `topic_insdt` datetime DEFAULT NULL,
  `topic_insip` varchar(45) DEFAULT NULL,
  `topic_insrid` int(11) DEFAULT NULL,
  `topic_logdt` datetime DEFAULT NULL,
  `topic_logip` varchar(45) DEFAULT NULL,
  `topic_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`topic_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `topic_master`
--

INSERT INTO `topic_master` (`topic_id`, `topic_subject_id`, `topic_name`, `topic_insdt`, `topic_insip`, `topic_insrid`, `topic_logdt`, `topic_logip`, `topic_logrid`) VALUES
(1, 1, 'GRAMER1', '2019-10-13 10:33:23', '1', 1, '2019-10-13 10:36:18', '1', 1),
(2, 3, 'XYZ', '2019-10-23 13:10:55', '1', 1, '2019-10-23 13:10:55', '1', 1),
(3, 1, 'KIIL', '2020-01-17 12:55:56', '1', 1, '2020-01-17 12:55:56', '1', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `video_all_data_get`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `video_all_data_get`;
CREATE TABLE IF NOT EXISTS `video_all_data_get` (
`video_id` int(11)
,`video_institute_id` int(11)
,`video_standard_id` int(11)
,`video_third_topic_id` int(11)
,`video_medium_id` int(11)
,`video_board_id` int(11)
,`video_language_id` int(11)
,`video_link` longtext
,`video_title` mediumtext
,`video_description` longtext
,`video_meta_tag` longtext
,`video_thumbnail_image` varchar(100)
,`video_insdt` datetime
,`video_insip` varchar(45)
,`video_insrid` int(11)
,`video_logdt` datetime
,`video_logip` varchar(45)
,`video_logrid` int(11)
,`third_topic_id` int(11)
,`third_topic_sub_topic_id` int(11)
,`third_topic_name` varchar(45)
,`sub_topic_id` int(11)
,`sub_topic_topic_id` varchar(45)
,`sub_topic_name` varchar(45)
,`topic_id` int(11)
,`topic_subject_id` int(11)
,`topic_name` varchar(45)
,`subject_id` int(11)
,`subject_name` varchar(45)
,`subject_image` longtext
,`standard_id` int(11)
,`standard_name` varchar(45)
,`id_id` int(11)
,`id_institute_code` varchar(45)
,`id_type` int(11)
,`id_name` varchar(45)
,`id_mobile_no` varchar(12)
,`id_email` varchar(45)
,`id_email_verification` varchar(45)
,`id_website` varchar(100)
,`id_website_verification` varchar(45)
,`id_address_line_1` varchar(45)
,`id_address_line_2` varchar(45)
,`id_landmark` varchar(45)
,`id_state_id` int(11)
,`id_district_id` int(11)
,`id_tahesil_id` int(11)
,`id_password` varchar(45)
,`id_verification_status` varchar(45)
,`id_date_of_registration` datetime
,`medium_id` int(11)
,`medium_name` varchar(45)
,`board_id` int(11)
,`board_name` varchar(45)
,`language_id` int(11)
,`language_name` varchar(45)
);

-- --------------------------------------------------------

--
-- Table structure for table `video_master`
--

DROP TABLE IF EXISTS `video_master`;
CREATE TABLE IF NOT EXISTS `video_master` (
  `video_id` int(11) NOT NULL AUTO_INCREMENT,
  `video_institute_id` int(11) DEFAULT NULL,
  `video_standard_id` int(11) DEFAULT NULL,
  `video_third_topic_id` int(11) DEFAULT NULL,
  `video_medium_id` int(11) DEFAULT NULL,
  `video_board_id` int(11) DEFAULT NULL,
  `video_language_id` int(11) DEFAULT NULL,
  `video_link` longtext,
  `video_title` mediumtext,
  `video_description` longtext,
  `video_meta_tag` longtext,
  `video_thumbnail_image` varchar(100) DEFAULT NULL,
  `video_insdt` datetime DEFAULT NULL,
  `video_insip` varchar(45) DEFAULT NULL,
  `video_insrid` int(11) DEFAULT NULL,
  `video_logdt` datetime DEFAULT NULL,
  `video_logip` varchar(45) DEFAULT NULL,
  `video_logrid` int(11) DEFAULT NULL,
  PRIMARY KEY (`video_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `video_master`
--

INSERT INTO `video_master` (`video_id`, `video_institute_id`, `video_standard_id`, `video_third_topic_id`, `video_medium_id`, `video_board_id`, `video_language_id`, `video_link`, `video_title`, `video_description`, `video_meta_tag`, `video_thumbnail_image`, `video_insdt`, `video_insip`, `video_insrid`, `video_logdt`, `video_logip`, `video_logrid`) VALUES
(1, 1, 1, 1, 1, 1, 1, 'https://www.youtube.com/watch?v=_AwMePp-j14', 'Joker | Play with fire', 'TuneCore (on behalf of Tinman Entertainment); BMI - Broadcast Music Inc., EMI Music Publishing, and 6 Music Rights Societies', '@jokar', '~/Admin/imagevideo/g2.jpg', '2019-11-25 12:12:53', '1', 1, '2020-01-17 13:59:31', '1', 1),
(2, 2, 1, 1, 1, 1, 1, 'https://www.youtube.com/watch?v=qvTXqNr0uZA', 'Joker escapes \\ Batman saves Dent ', 'The Dark Knight (2008) Scene: Joker escapes \\ Batman saves Dent', '@jajja', '~/Admin/imagevideo/Hotel.jpg', '2019-11-26 14:32:46', '1', 1, '2019-11-26 14:32:46', '1', 1);

-- --------------------------------------------------------

--
-- Structure for view `country_state_view`
--
DROP TABLE IF EXISTS `country_state_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `country_state_view`  AS  select `cm`.`country_id` AS `country_id`,`cm`.`country_name` AS `country_name`,`cm`.`country_insdt` AS `country_insdt`,`cm`.`country_insrid` AS `country_insrid`,`cm`.`country_logdt` AS `country_logdt`,`cm`.`country_logrid` AS `country_logrid`,`sm`.`state_id` AS `state_id`,`sm`.`state_country_id` AS `state_country_id`,`sm`.`state_name` AS `state_name`,`sm`.`state_insdt` AS `state_insdt`,`sm`.`state_insrid` AS `state_insrid`,`sm`.`state_logdt` AS `state_logdt`,`sm`.`state_logrid` AS `state_logrid` from (`country_master` `cm` join `state_master` `sm` on((`cm`.`country_id` = `sm`.`state_country_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `distric_taluka_data_view`
--
DROP TABLE IF EXISTS `distric_taluka_data_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `distric_taluka_data_view`  AS  select `dm`.`distric_id` AS `distric_id`,`dm`.`distric_state_id` AS `distric_state_id`,`dm`.`distric_name` AS `distric_name`,`dm`.`distric_insdt` AS `distric_insdt`,`dm`.`distric_insrid` AS `distric_insrid`,`dm`.`distric_logdt` AS `distric_logdt`,`dm`.`distric_logrid` AS `distric_logrid`,`tm`.`taluka_id` AS `taluka_id`,`tm`.`taluka_distric_id` AS `taluka_distric_id`,`tm`.`taluka_name` AS `taluka_name`,`tm`.`taluka_insdt` AS `taluka_insdt`,`tm`.`taluka_insrid` AS `taluka_insrid`,`tm`.`taluka_logdt` AS `taluka_logdt`,`tm`.`taluka_logrid` AS `taluka_logrid` from (`distric_master` `dm` join `taluka_master` `tm` on((`dm`.`distric_id` = `tm`.`taluka_distric_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `get_sub_topic_details`
--
DROP TABLE IF EXISTS `get_sub_topic_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_sub_topic_details`  AS  select `stm`.`sub_topic_id` AS `sub_topic_id`,`stm`.`sub_topic_topic_id` AS `sub_topic_topic_id`,`stm`.`sub_topic_name` AS `sub_topic_name`,`stm`.`sub_topic_insdt` AS `sub_topic_insdt`,`stm`.`sub_topic_insip` AS `sub_topic_insip`,`stm`.`sub_topic_insrid` AS `sub_topic_insrid`,`stm`.`sub_topic_logdt` AS `sub_topic_logdt`,`stm`.`sub_topic_logip` AS `sub_topic_logip`,`stm`.`sub_topic_logrid` AS `sub_topic_logrid`,`gtd`.`topic_id` AS `topic_id`,`gtd`.`topic_subject_id` AS `topic_subject_id`,`gtd`.`topic_name` AS `topic_name`,`gtd`.`topic_insdt` AS `topic_insdt`,`gtd`.`topic_insip` AS `topic_insip`,`gtd`.`topic_insrid` AS `topic_insrid`,`gtd`.`topic_logdt` AS `topic_logdt`,`gtd`.`topic_logip` AS `topic_logip`,`gtd`.`topic_logrid` AS `topic_logrid`,`gtd`.`subject_id` AS `subject_id`,`gtd`.`subject_name` AS `subject_name`,`gtd`.`subject_image` AS `subject_image`,`gtd`.`subject_insdt` AS `subject_insdt`,`gtd`.`subject_insip` AS `subject_insip`,`gtd`.`subject_insrid` AS `subject_insrid`,`gtd`.`subject_logdt` AS `subject_logdt`,`gtd`.`subject_logip` AS `subject_logip`,`gtd`.`subject_logrid` AS `subject_logrid` from (`sub_topic_master` `stm` left join `get_topic_details` `gtd` on((`gtd`.`topic_id` = `stm`.`sub_topic_topic_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `get_third_topic_details`
--
DROP TABLE IF EXISTS `get_third_topic_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_third_topic_details`  AS  select `tm`.`third_topic_id` AS `third_topic_id`,`tm`.`third_topic_sub_topic_id` AS `third_topic_sub_topic_id`,`tm`.`third_topic_name` AS `third_topic_name`,`tm`.`third_topic_insdt` AS `third_topic_insdt`,`tm`.`third_topic_insip` AS `third_topic_insip`,`tm`.`third_topic_insrid` AS `third_topic_insrid`,`tm`.`third_topic_logdt` AS `third_topic_logdt`,`tm`.`third_topic_logip` AS `third_topic_logip`,`tm`.`third_topic_logrid` AS `third_topic_logrid`,`gsd`.`sub_topic_id` AS `sub_topic_id`,`gsd`.`sub_topic_topic_id` AS `sub_topic_topic_id`,`gsd`.`sub_topic_name` AS `sub_topic_name`,`gsd`.`sub_topic_insdt` AS `sub_topic_insdt`,`gsd`.`sub_topic_insip` AS `sub_topic_insip`,`gsd`.`sub_topic_insrid` AS `sub_topic_insrid`,`gsd`.`sub_topic_logdt` AS `sub_topic_logdt`,`gsd`.`sub_topic_logip` AS `sub_topic_logip`,`gsd`.`sub_topic_logrid` AS `sub_topic_logrid`,`gsd`.`topic_id` AS `topic_id`,`gsd`.`topic_subject_id` AS `topic_subject_id`,`gsd`.`topic_name` AS `topic_name`,`gsd`.`topic_insdt` AS `topic_insdt`,`gsd`.`topic_insip` AS `topic_insip`,`gsd`.`topic_insrid` AS `topic_insrid`,`gsd`.`topic_logdt` AS `topic_logdt`,`gsd`.`topic_logip` AS `topic_logip`,`gsd`.`topic_logrid` AS `topic_logrid`,`gsd`.`subject_id` AS `subject_id`,`gsd`.`subject_name` AS `subject_name`,`gsd`.`subject_image` AS `subject_image`,`gsd`.`subject_insdt` AS `subject_insdt`,`gsd`.`subject_insip` AS `subject_insip`,`gsd`.`subject_insrid` AS `subject_insrid`,`gsd`.`subject_logdt` AS `subject_logdt`,`gsd`.`subject_logip` AS `subject_logip`,`gsd`.`subject_logrid` AS `subject_logrid` from (`third_topic_master` `tm` left join `get_sub_topic_details` `gsd` on((`tm`.`third_topic_sub_topic_id` = `gsd`.`sub_topic_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `get_topic_details`
--
DROP TABLE IF EXISTS `get_topic_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_topic_details`  AS  select `tm`.`topic_id` AS `topic_id`,`tm`.`topic_subject_id` AS `topic_subject_id`,`tm`.`topic_name` AS `topic_name`,`tm`.`topic_insdt` AS `topic_insdt`,`tm`.`topic_insip` AS `topic_insip`,`tm`.`topic_insrid` AS `topic_insrid`,`tm`.`topic_logdt` AS `topic_logdt`,`tm`.`topic_logip` AS `topic_logip`,`tm`.`topic_logrid` AS `topic_logrid`,`sm`.`subject_id` AS `subject_id`,`sm`.`subject_name` AS `subject_name`,`sm`.`subject_image` AS `subject_image`,`sm`.`subject_insdt` AS `subject_insdt`,`sm`.`subject_insip` AS `subject_insip`,`sm`.`subject_insrid` AS `subject_insrid`,`sm`.`subject_logdt` AS `subject_logdt`,`sm`.`subject_logip` AS `subject_logip`,`sm`.`subject_logrid` AS `subject_logrid` from (`topic_master` `tm` left join `subject_master` `sm` on((`tm`.`topic_subject_id` = `sm`.`subject_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `institute_and_institute_link_studant_data_fill_view`
--
DROP TABLE IF EXISTS `institute_and_institute_link_studant_data_fill_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `institute_and_institute_link_studant_data_fill_view`  AS  select `sdl`.`sil_id` AS `sil_id`,`sdl`.`sil_id_id` AS `sil_id_id`,`sdl`.`sil_stud_id` AS `sil_stud_id`,`sdl`.`sil_verification_status` AS `sil_verification_status`,`id`.`id_id` AS `id_id`,`id`.`id_institute_code` AS `id_institute_code`,`id`.`id_type` AS `id_type`,`id`.`id_name` AS `id_name`,`id`.`id_mobile_no` AS `id_mobile_no`,`id`.`id_email` AS `id_email`,`id`.`id_email_verification` AS `id_email_verification`,`id`.`id_website` AS `id_website`,`id`.`id_website_verification` AS `id_website_verification`,`id`.`id_address_line_1` AS `id_address_line_1`,`id`.`id_address_line_2` AS `id_address_line_2`,`id`.`id_landmark` AS `id_landmark`,`id`.`id_state_id` AS `id_state_id`,`id`.`id_district_id` AS `id_district_id`,`id`.`id_tahesil_id` AS `id_tahesil_id`,`id`.`id_password` AS `id_password`,`id`.`id_verification_status` AS `id_verification_status`,`id`.`id_date_of_registration` AS `id_date_of_registration`,`id`.`id_logdt` AS `id_logdt`,`id`.`id_logrid` AS `id_logrid`,`sd`.`stud_id` AS `stud_id`,`sd`.`stud_first_name` AS `stud_first_name`,`sd`.`stud_middle_name` AS `stud_middle_name`,`sd`.`stud_last_name` AS `stud_last_name`,`sd`.`stud_gender` AS `stud_gender`,`sd`.`stud_mobile_no` AS `stud_mobile_no`,`sd`.`stud_dob` AS `stud_dob`,`sd`.`stud_email` AS `stud_email`,`sd`.`stud_std_id` AS `stud_std_id`,`sd`.`stud_password` AS `stud_password`,`sd`.`stud_status` AS `stud_status`,`sd`.`stud_insdt` AS `stud_insdt`,`sd`.`stud_insip` AS `stud_insip`,`sd`.`stud_insrid` AS `stud_insrid`,`sd`.`stud_logdt` AS `stud_logdt`,`sd`.`stud_logip` AS `stud_logip`,`sd`.`stud_logrid` AS `stud_logrid`,`sm`.`standard_id` AS `standard_id`,`sm`.`standard_name` AS `standard_name` from (((`student_institute_link` `sdl` left join `institute_details` `id` on((`sdl`.`sil_id_id` = `id`.`id_id`))) left join `student_details` `sd` on((`sd`.`stud_id` = `sdl`.`sil_stud_id`))) left join `standard_master` `sm` on((`sm`.`standard_id` = `sd`.`stud_std_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `institute_and_institute_type_data_view`
--
DROP TABLE IF EXISTS `institute_and_institute_type_data_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `institute_and_institute_type_data_view`  AS  select `id`.`id_id` AS `id_id`,`id`.`id_institute_code` AS `id_institute_code`,`id`.`id_type` AS `id_type`,`id`.`id_name` AS `id_name`,`id`.`id_mobile_no` AS `id_mobile_no`,`id`.`id_email` AS `id_email`,`id`.`id_email_verification` AS `id_email_verification`,`id`.`id_website` AS `id_website`,`id`.`id_website_verification` AS `id_website_verification`,`id`.`id_address_line_1` AS `id_address_line_1`,`id`.`id_address_line_2` AS `id_address_line_2`,`id`.`id_landmark` AS `id_landmark`,`id`.`id_state_id` AS `id_state_id`,`id`.`id_district_id` AS `id_district_id`,`id`.`id_tahesil_id` AS `id_tahesil_id`,`id`.`id_password` AS `id_password`,`id`.`id_verification_status` AS `id_verification_status`,`id`.`id_date_of_registration` AS `id_date_of_registration`,`id`.`id_logdt` AS `id_logdt`,`id`.`id_logrid` AS `id_logrid`,`itm`.`institute_type_id` AS `institute_type_id`,`itm`.`institute_type_name` AS `institute_type_name`,`itm`.`institute_type_insdt` AS `institute_type_insdt`,`itm`.`institute_type_insip` AS `institute_type_insip`,`itm`.`institute_type_insrid` AS `institute_type_insrid`,`itm`.`institute_type_logdt` AS `institute_type_logdt`,`itm`.`institute_type_logip` AS `institute_type_logip`,`itm`.`institute_type_logrid` AS `institute_type_logrid` from (`institute_details` `id` join `institute_type_master` `itm` on((`id`.`id_type` = `itm`.`institute_type_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `state_and_distric_data_view`
--
DROP TABLE IF EXISTS `state_and_distric_data_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `state_and_distric_data_view`  AS  select `sm`.`state_id` AS `state_id`,`sm`.`state_country_id` AS `state_country_id`,`sm`.`state_name` AS `state_name`,`sm`.`state_insdt` AS `state_insdt`,`sm`.`state_insrid` AS `state_insrid`,`sm`.`state_logdt` AS `state_logdt`,`sm`.`state_logrid` AS `state_logrid`,`dm`.`distric_id` AS `distric_id`,`dm`.`distric_state_id` AS `distric_state_id`,`dm`.`distric_name` AS `distric_name`,`dm`.`distric_insdt` AS `distric_insdt`,`dm`.`distric_insrid` AS `distric_insrid`,`dm`.`distric_logdt` AS `distric_logdt`,`dm`.`distric_logrid` AS `distric_logrid` from (`state_master` `sm` join `distric_master` `dm` on((`sm`.`state_id` = `dm`.`distric_state_id`))) ;

-- --------------------------------------------------------

--
-- Structure for view `video_all_data_get`
--
DROP TABLE IF EXISTS `video_all_data_get`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `video_all_data_get`  AS  select `vm`.`video_id` AS `video_id`,`vm`.`video_institute_id` AS `video_institute_id`,`vm`.`video_standard_id` AS `video_standard_id`,`vm`.`video_third_topic_id` AS `video_third_topic_id`,`vm`.`video_medium_id` AS `video_medium_id`,`vm`.`video_board_id` AS `video_board_id`,`vm`.`video_language_id` AS `video_language_id`,`vm`.`video_link` AS `video_link`,`vm`.`video_title` AS `video_title`,`vm`.`video_description` AS `video_description`,`vm`.`video_meta_tag` AS `video_meta_tag`,`vm`.`video_thumbnail_image` AS `video_thumbnail_image`,`vm`.`video_insdt` AS `video_insdt`,`vm`.`video_insip` AS `video_insip`,`vm`.`video_insrid` AS `video_insrid`,`vm`.`video_logdt` AS `video_logdt`,`vm`.`video_logip` AS `video_logip`,`vm`.`video_logrid` AS `video_logrid`,`gttd`.`third_topic_id` AS `third_topic_id`,`gttd`.`third_topic_sub_topic_id` AS `third_topic_sub_topic_id`,`gttd`.`third_topic_name` AS `third_topic_name`,`gttd`.`sub_topic_id` AS `sub_topic_id`,`gttd`.`sub_topic_topic_id` AS `sub_topic_topic_id`,`gttd`.`sub_topic_name` AS `sub_topic_name`,`gttd`.`topic_id` AS `topic_id`,`gttd`.`topic_subject_id` AS `topic_subject_id`,`gttd`.`topic_name` AS `topic_name`,`gttd`.`subject_id` AS `subject_id`,`gttd`.`subject_name` AS `subject_name`,`gttd`.`subject_image` AS `subject_image`,`sm`.`standard_id` AS `standard_id`,`sm`.`standard_name` AS `standard_name`,`ind`.`id_id` AS `id_id`,`ind`.`id_institute_code` AS `id_institute_code`,`ind`.`id_type` AS `id_type`,`ind`.`id_name` AS `id_name`,`ind`.`id_mobile_no` AS `id_mobile_no`,`ind`.`id_email` AS `id_email`,`ind`.`id_email_verification` AS `id_email_verification`,`ind`.`id_website` AS `id_website`,`ind`.`id_website_verification` AS `id_website_verification`,`ind`.`id_address_line_1` AS `id_address_line_1`,`ind`.`id_address_line_2` AS `id_address_line_2`,`ind`.`id_landmark` AS `id_landmark`,`ind`.`id_state_id` AS `id_state_id`,`ind`.`id_district_id` AS `id_district_id`,`ind`.`id_tahesil_id` AS `id_tahesil_id`,`ind`.`id_password` AS `id_password`,`ind`.`id_verification_status` AS `id_verification_status`,`ind`.`id_date_of_registration` AS `id_date_of_registration`,`mm`.`medium_id` AS `medium_id`,`mm`.`medium_name` AS `medium_name`,`bm`.`board_id` AS `board_id`,`bm`.`board_name` AS `board_name`,`lm`.`language_id` AS `language_id`,`lm`.`language_name` AS `language_name` from ((((((`video_master` `vm` left join `get_third_topic_details` `gttd` on((`gttd`.`third_topic_id` = `vm`.`video_third_topic_id`))) left join `standard_master` `sm` on((`sm`.`standard_id` = `vm`.`video_standard_id`))) left join `institute_details` `ind` on((`ind`.`id_id` = `vm`.`video_institute_id`))) left join `medium_master` `mm` on((`mm`.`medium_id` = `vm`.`video_medium_id`))) left join `board_master` `bm` on((`bm`.`board_id` = `vm`.`video_board_id`))) left join `language_master` `lm` on((`lm`.`language_id` = `vm`.`video_language_id`))) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
