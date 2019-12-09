<?php

namespace App\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class InstallCommand extends Command
{

    protected function configure()
    {
        $this
            // the name of the command (the part after 'bin/console')
            ->setName('app:install')
            // the short description shown while running "php bin/console list"
            ->setDescription('Application installation')
            // the full command description shown when running the command with
            // the "--help" option
            ->setHelp('Application installation')
            ->addOption('command', null, InputOption::VALUE_OPTIONAL, 'Command up - install, down - uninstall', 'up');
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        try {
            $dir = realpath(__DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR);
            $output->writeln(sprintf('<info>%s, DIRECTORY: %s</info>', $this->getDescription(), $dir));
            switch($input->getOption('command'))
            {
                default:
                        $commands[] = 'cd ' . $dir . ' && composer update';
                        $commands[] = 'cd ' . $dir . ' && yarn install';
                        $commands[] = 'cd ' . $dir . ' && php bin/console doctrine:migrations:execute --up 20191207082243';
                        $commands[] = 'cd ' . $dir . ' && php bin/console doctrine:fixtures:load';
                        $commands[] = 'cd ' . $dir . ' && php bin/console cache:clear';
                    break;
                case 'down':
                        $commands[] = 'cd ' . $dir . ' && php bin/console doctrine:migrations:execute --down 20191207082243';
                        $commands[] = 'cd ' . $dir . ' && php bin/console cache:clear';
                    break;
            }
            foreach ($commands as $command) {
                $output->writeln(sprintf("<info>Execute %s</info>", $command));
                $process = new Process($command);
                $process->run();
                if (!$process->isSuccessful()) {
                    throw new ProcessFailedException($process);
                }
                $output->writeln($process->getOutput());
            }
        } catch (\Exception $e) {
            $output->writeln(sprintf("<error>Exception\n%s\n%s</error>", $e->getMessage(), $e->getTraceAsString()));
        }
    }

}
