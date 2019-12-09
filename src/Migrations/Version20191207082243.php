<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;
use Symfony\Component\Filesystem\Filesystem;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

/**
 * Auto-generated Migration: Please modify to your needs!
 * To pgdump sudo pg_dump --clean --schema-only --schema=public --exclude-table=migration_versions -U postgres -d tmsneek -h 127.0.0.1 -p 5432 -f /home/piotr/www/symfony/tmsneek/src/Migrations/postgresql/20191207082243/up.sql && sudo chown piotr:piotr /home/piotr/www/symfony/tmsneek/src/Migrations/postgresql -R
 * To pgdump file add "SET search_path = 'public';"
 *
 */
final class Version20191207082243 extends AbstractMigration
{
    public function getDescription() : string
    {
        return '';
    }

    public function up(Schema $schema) : void
    {
        if($this->connection->getDatabasePlatform()->getName() == 'mysql') {
            $this->addSql('DELETE FROM migration_versions WHERE version=\'' . $this->version . '\'');
        } elseif ($this->connection->getDatabasePlatform()->getName() == 'postgresql') {
            $this->addSql('DELETE FROM public.migration_versions pmv WHERE pmv."version"=\'' . $this->version . '\'');
        }
        $this->addSqlFromFile('up.sql');
    }

    public function down(Schema $schema) : void
    {
        if($this->connection->getDatabasePlatform()->getName() == 'mysql') {
            $this->addSql('DELETE FROM migration_versions WHERE version=\'' . $this->version . '\'');
        } elseif ($this->connection->getDatabasePlatform()->getName() == 'postgresql') {
            $this->addSql('DELETE FROM public.migration_versions pmv WHERE pmv."version"=\'' . $this->version . '\'');
        }
        $this->addSqlFromFile('down.sql');
    }

    private function addSqlFromFile(?string $file)
    {
        $sql = $this->getFilePath($file);
        $this->abortIf(!file_exists($sql), 'Plik ' . $sql . ' nie istnieje! Proszę utworzyć plik migracji korzystając z programu dump twojej bazy danych.');
        $params = $this->connection->getParams();
        if($this->connection->getDatabasePlatform()->getName() == 'mysql') {
            $command = sprintf("mysql -f --host='%s' --port='%s' --user='%s' --password='%s' %s < '%s'", $params['host'], $params['port'], $params['user'], $params['password'], $params['dbname'], $sql);
        } elseif ($this->connection->getDatabasePlatform()->getName() == 'postgresql') {
            $command = sprintf("psql \"%s\" -f %s", preg_replace('/pgsql/', 'postgresql', $params['url']), $sql);
        }
        $this->write(sprintf("<info>Execute %s</info>", $command));
        $process = new Process($command);
        $process->run();
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }
        $this->write($process->getOutput());
    }

    private function getFilePath(?string $file)
    {
        $dir = __DIR__ . DIRECTORY_SEPARATOR . $this->connection->getDatabasePlatform()->getName() . DIRECTORY_SEPARATOR . $this->version;
        $sql = $dir . DIRECTORY_SEPARATOR . $file;
        $filesystem = new Filesystem();
        $filesystem->mkdir($dir, 0777);
        return $sql;
    }

}
