<?php

namespace App\DataFixtures;

use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;


use App\Entity\Status;
use App\Entity\Customer;
use App\Entity\Employee;
use App\Entity\ProjectList;
use App\Entity\TaskList;
use App\Entity\TaskDetails;

class AppFixtures extends Fixture
{
    protected const COUNTER = 32;

    public function load(ObjectManager $manager)
    {
        //create Status.
        $status = new Status();
        $status->setName('Otwarte');
        $status->setPriority(1);
        $manager->persist($status);
        $manager->flush();
        $statuses[] = $status;
        //create Status.
        $status = new Status();
        $status->setName('W trakcie roziązania');
        $status->setPriority(2);
        $manager->persist($status);
        $manager->flush();
        $statuses[] = $status;
        //create Status.
        $status = new Status();
        $status->setName('Zamknięte');
        $status->setPriority(3);
        $manager->persist($status);
        $manager->flush();
        $statuses[] = $status;

        //create Customer.
        for ($i = 0; $i < self::COUNTER; $i++)
        {
            $customer = new Customer();
            $customer->setName('Customer ' . $i);
            $manager->persist($customer);
            $manager->flush();
            $customers[] = $customer;
        }

        //create Employee.
        for ($i = 0; $i < self::COUNTER; $i++)
        {
            $employee = new Employee();
            $employee->setName('Employee name ' . $i);
            $employee->setSurname('Employee surname ' . $i);
            $employee->setEmail('employee.email ' . $i . '@email.com');
            $manager->persist($employee);
            $manager->flush();
            $employees[] = $employee;
        }

        //create ProjectList.
        for ($i = 0; $i < self::COUNTER; $i++)
        {
            $project_list = new ProjectList();
            $project_list->setCustomer($customers[array_rand($customers)]);
            $project_list->setProjectName('Project List name ' . $i);
            $project_list->setPercentage(0);
            $manager->persist($project_list);
            $manager->flush();
            $project_lists[] = $project_list;
        }

        //create TaskList.
        for ($i = 0; $i < self::COUNTER * 4; $i++)
        {
            $task_list = new TaskList();
            $task_list->setProjectList($project_lists[array_rand($project_lists)]);
            $task_list->setStatus($statuses[array_rand($statuses)]);
            $task_list->setName('Task List ' . $i);
            $task_list->setCreationDate(new \DateTime(date('Y-m-d H:i:s', mt_rand(strtotime("2019-01-01 00:00:00"),strtotime("now")))));
            $task_list->setPriority(rand(0,9));
            $manager->persist($task_list);
            $manager->flush();
            $task_lists[] = $task_list;
        }

        //create TaskDetails
        for ($i = 0; $i < self::COUNTER * 16; $i++)
        {
            $task_details = new TaskDetails();
            $task_details->setTaskList($task_lists[array_rand($task_lists)]);
            $task_details->setEmployee($employees[array_rand($employees)]);
            $task_details->setName('Task Details ' . $i);
            $task_details->setDescription('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');
            $task_details->setCreationDate(new \DateTime(date('Y-m-d H:i:s', mt_rand(strtotime("2019-01-01 00:00:00"),strtotime("now")))));
            $manager->persist($task_details);
            $manager->flush();
        }

    }
}
