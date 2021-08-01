BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"IconUrl__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'','Cuenta de ejemplo para asignaciones','');
INSERT INTO "Account" VALUES(2,'','Byrd, Haynes and Schwartz','');
INSERT INTO "Account" VALUES(3,'','Morgan-Montgomery','');
INSERT INTO "Account" VALUES(4,'','Dougherty and Sons','');
INSERT INTO "Account" VALUES(5,'','Rhodes-Mclaughlin','');
INSERT INTO "Account" VALUES(6,'','Dawson, Daniels and Moss','');
INSERT INTO "Account" VALUES(7,'','Durham-Gordon','');
INSERT INTO "Account" VALUES(8,'','Dennis, Lucero and Rivers','');
INSERT INTO "Account" VALUES(9,'','Hendricks-Zhang','');
INSERT INTO "Account" VALUES(10,'','Lucas, Zuniga and James','');
INSERT INTO "Account" VALUES(11,'','Gordon, King and Harvey','');
INSERT INTO "Account" VALUES(12,'','Kaufman-Ayers','');
INSERT INTO "Account" VALUES(13,'','Keller, Valdez and Reese','');
INSERT INTO "Account" VALUES(14,'','Stevenson-Baxter','');
INSERT INTO "Account" VALUES(15,'','Curtis, Barajas and Gibson','');
INSERT INTO "Account" VALUES(16,'','Gould-Bolton','');
INSERT INTO "Account" VALUES(17,'','Brown, Tate and Mcdaniel','');
INSERT INTO "Account" VALUES(18,'','Cain-Lyons','');
INSERT INTO "Account" VALUES(19,'','Sullivan-Bradshaw','');
INSERT INTO "Account" VALUES(20,'','Brock-Weber','');
INSERT INTO "Account" VALUES(21,'','Mueller LLC','');
CREATE TABLE "Category__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Category__c" VALUES(1,'Category 1');
INSERT INTO "Category__c" VALUES(2,'Category 2');
INSERT INTO "Category__c" VALUES(3,'Category 3');
INSERT INTO "Category__c" VALUES(4,'Category 4');
INSERT INTO "Category__c" VALUES(5,'Category 5');
INSERT INTO "Category__c" VALUES(6,'Category 6');
INSERT INTO "Category__c" VALUES(7,'Category 7');
INSERT INTO "Category__c" VALUES(8,'Category 8');
INSERT INTO "Category__c" VALUES(9,'Category 9');
INSERT INTO "Category__c" VALUES(10,'Category 10');
INSERT INTO "Category__c" VALUES(11,'Category 11');
INSERT INTO "Category__c" VALUES(12,'Category 12');
INSERT INTO "Category__c" VALUES(13,'Category 13');
INSERT INTO "Category__c" VALUES(14,'Category 14');
INSERT INTO "Category__c" VALUES(15,'Category 15');
INSERT INTO "Category__c" VALUES(16,'Category 16');
INSERT INTO "Category__c" VALUES(17,'Category 17');
INSERT INTO "Category__c" VALUES(18,'Category 18');
INSERT INTO "Category__c" VALUES(19,'Category 19');
INSERT INTO "Category__c" VALUES(20,'Category 20');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"Active__c" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'True','Shaun','Zamora','','');
INSERT INTO "Contact" VALUES(2,'False','Carly','Castillo','','');
INSERT INTO "Contact" VALUES(3,'True','Vernon','Becker','','');
INSERT INTO "Contact" VALUES(4,'True','Javier','Sellers','','');
INSERT INTO "Contact" VALUES(5,'True','Lance','Neal','','');
INSERT INTO "Contact" VALUES(6,'True','Tony','Cross','','');
INSERT INTO "Contact" VALUES(7,'True','Alex','Branch','','');
INSERT INTO "Contact" VALUES(8,'True','Mia','Conrad','','');
INSERT INTO "Contact" VALUES(9,'False','Lance','Oconnell','','');
INSERT INTO "Contact" VALUES(10,'False','Joann','Spence','','');
INSERT INTO "Contact" VALUES(11,'True','Makayla','Burgess','','');
INSERT INTO "Contact" VALUES(12,'False','Vickie','Montgomery','','');
INSERT INTO "Contact" VALUES(13,'True','Kim','Campbell','','');
INSERT INTO "Contact" VALUES(14,'False','Hector','Acevedo','','');
INSERT INTO "Contact" VALUES(15,'False','Connie','Best','','');
INSERT INTO "Contact" VALUES(16,'True','Dustin','Griffin','','');
INSERT INTO "Contact" VALUES(17,'True','Valerie','Conley','','');
INSERT INTO "Contact" VALUES(18,'True','Collin','Watts','','');
INSERT INTO "Contact" VALUES(19,'False','Darren','Gill','','');
INSERT INTO "Contact" VALUES(20,'False','Patrick','Thompson','','');
CREATE TABLE "Event__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Total_spent__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Event__c" VALUES(1,'Event 1','94896.0');
INSERT INTO "Event__c" VALUES(2,'Event 2','36420.0');
INSERT INTO "Event__c" VALUES(3,'Event 3','80875.0');
INSERT INTO "Event__c" VALUES(4,'Event 4','');
INSERT INTO "Event__c" VALUES(5,'Event 5','22996.0');
INSERT INTO "Event__c" VALUES(6,'Event 6','76826.0');
INSERT INTO "Event__c" VALUES(7,'Event 7','');
INSERT INTO "Event__c" VALUES(8,'Event 8','69186.0');
INSERT INTO "Event__c" VALUES(9,'Event 9','79642.0');
INSERT INTO "Event__c" VALUES(10,'Event 10','114593.0');
INSERT INTO "Event__c" VALUES(11,'Event 11','');
INSERT INTO "Event__c" VALUES(12,'Event 12','');
INSERT INTO "Event__c" VALUES(13,'Event 13','58001.0');
INSERT INTO "Event__c" VALUES(14,'Event 14','');
INSERT INTO "Event__c" VALUES(15,'Event 15','');
INSERT INTO "Event__c" VALUES(16,'Event 16','');
INSERT INTO "Event__c" VALUES(17,'Event 17','46792.0');
INSERT INTO "Event__c" VALUES(18,'Event 18','37492.0');
INSERT INTO "Event__c" VALUES(19,'Event 19','186546.0');
INSERT INTO "Event__c" VALUES(20,'Event 20','101700.0');
CREATE TABLE "Transaction__c" (
	id INTEGER NOT NULL, 
	"Amount__c" VARCHAR(255), 
	"Date__c" VARCHAR(255), 
	"Description__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Billed_to__c" VARCHAR(255), 
	"Category__c" VARCHAR(255), 
	"Event__c" VARCHAR(255), 
	"Paid_By__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Transaction__c" VALUES(1,'215.0','2021-06-18','Few senior improve.','15','13','9','8','2');
INSERT INTO "Transaction__c" VALUES(2,'9540.0','2021-07-31','Possible need support citizen.','7','5','14','1','5');
INSERT INTO "Transaction__c" VALUES(3,'20829.0','2021-05-29','Campaign whether couple remain.','11','15','16','10','18');
INSERT INTO "Transaction__c" VALUES(4,'87518.0','2020-08-13','Lose question write somebody hand.','14','20','12','19','20');
INSERT INTO "Transaction__c" VALUES(5,'411.0','2021-06-11','Yourself about a three.','2','8','5','20','14');
INSERT INTO "Transaction__c" VALUES(6,'47923.0','2020-10-29','Relate that fly. Stock of set.','9','9','20','20','15');
INSERT INTO "Transaction__c" VALUES(7,'37492.0','2020-11-17','Glass American stage.','12','7','2','18','18');
INSERT INTO "Transaction__c" VALUES(8,'76826.0','2021-05-10','Produce win particularly above suggest.','14','12','14','6','17');
INSERT INTO "Transaction__c" VALUES(9,'72329.0','2021-07-10','Occur should affect cause short.','8','19','13','3','13');
INSERT INTO "Transaction__c" VALUES(10,'99028.0','2021-05-28','Maintain north parent Mr.','3','14','1','19','4');
INSERT INTO "Transaction__c" VALUES(11,'68971.0','2021-03-07','Build senior born send.','8','15','14','8','10');
INSERT INTO "Transaction__c" VALUES(12,'53366.0','2021-06-02','City news purpose find buy account.','16','20','2','20','7');
INSERT INTO "Transaction__c" VALUES(13,'46792.0','2021-03-02','Yes yes here especially among.','10','8','4','17','8');
INSERT INTO "Transaction__c" VALUES(14,'36420.0','2020-09-04','Contain agreement threat parent.','17','1','9','2','17');
INSERT INTO "Transaction__c" VALUES(15,'8546.0','2020-12-14','Security measure some why east toward.','12','19','5','3','3');
INSERT INTO "Transaction__c" VALUES(16,'85356.0','2021-05-17','Fall really course kitchen about data.','7','5','16','1','17');
INSERT INTO "Transaction__c" VALUES(17,'58001.0','2020-11-03','Reveal pick consider book successful.','9','13','18','13','9');
INSERT INTO "Transaction__c" VALUES(18,'79642.0','2021-05-30','Employee simple capital edge magazine.','12','15','3','9','9');
INSERT INTO "Transaction__c" VALUES(19,'93764.0','2021-03-04','Quickly military table interest.','15','4','12','10','5');
INSERT INTO "Transaction__c" VALUES(20,'22996.0','2021-07-22','Lay across throughout.','10','6','9','5','4');
COMMIT;
