-- altere a localização dos ficheiros para a sua máquina
use master;
CREATE DATABASE GSI_AP3
ON PRIMARY
( NAME = db_dat,
FILENAME = 'H:\gsi\db1.mdf',
SIZE = 5MB),
FILEGROUP FG1
( NAME = FG1_dat,
FILENAME = 'H:\gsi\FG1.ndf',
SIZE = 2MB),
FILEGROUP FG2
( NAME = FG2_dat,
FILENAME = 'H:\gsi\FG2.ndf',
SIZE = 2MB)
LOG ON
( NAME = db_log,
FILENAME = 'H:\gsi\log1.ndf',
SIZE = 2MB,
FILEGROWTH = 10% );
GO

use GSI_AP3


CREATE PARTITION FUNCTION pf (int) AS
RANGE LEFT FOR VALUES (5000);

CREATE PARTITION SCHEME ps AS
PARTITION pf TO
([FG1], [FG2])


