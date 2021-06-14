-- altere a localização dos ficheiros para a sua máquina
use master;
CREATE DATABASE GSI_AP3
ON PRIMARY
( NAME = db_dat,
FILENAME = 'C:\DADOS\Aulas\GSI_2020_21\Práticas\Prática3\teste\db1.mdf',
SIZE = 5MB),
FILEGROUP FG1
( NAME = FG1_dat,
FILENAME = 'C:\DADOS\Aulas\GSI_2020_21\Práticas\Prática3\teste\FG1.ndf',
SIZE = 2MB),
FILEGROUP FG2
( NAME = FG2_dat,
FILENAME = 'C:\DADOS\Aulas\GSI_2020_21\Práticas\Prática3\teste\FG2.ndf',
SIZE = 2MB)
LOG ON
( NAME = db_log,
FILENAME = 'C:\DADOS\Aulas\GSI_2020_21\Práticas\Prática3\teste\log1.ndf',
SIZE = 2MB,
FILEGROWTH = 10% );
GO

use GSI_AP3


CREATE PARTITION FUNCTION pf (int) AS
RANGE LEFT FOR VALUES (5000);

CREATE PARTITION SCHEME ps AS
PARTITION pf TO
([FG1], [FG2])


