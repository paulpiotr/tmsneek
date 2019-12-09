<?php

namespace App\Repository;

use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\Tools\Pagination\Paginator;
use Doctrine\Common\Persistence\ManagerRegistry;
use App\Entity\TaskDetails;
use Symfony\Component\HttpFoundation\Request;

class TaskDetailsRepository extends ServiceEntityRepository
{

    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TaskDetails::class);
    }

    /**
     * Paginator Helper
     *
     * Pass through a query object, current page & limit
     * the offset is calculated from the page and limit
     * returns an `Paginator` instance, which you can call the following on:
     *
     * $paginator->getIterator()->count() # Total fetched (ie: `5` posts)
     * $paginator->count() # Count of ALL posts (ie: `20` posts)
     * $paginator->getIterator() # ArrayIterator
     *
     * @param Doctrine\ORM\Query $dql DQL Query Object
     * @param integer $page  Current page (defaults to 1)
     * @param integer $limit The total number per page (defaults to 5)
     *
     * @return \Doctrine\ORM\Tools\Pagination\Paginator|array
     */
    public function paginator($dql, $page = 1, $limit = 5)
    {
        try {
            $paginator = new Paginator($dql);
            $paginator->getQuery()
                ->setFirstResult($limit * ($page - 1)) // Offset
                ->setMaxResults($limit); // Limit
            return $paginator;
        } catch (\Exception $e) {
            return [
                'status' => 500,
                'message' => $e->getMessage(),
                'trace_as_string' => $e->getTraceAsString(),
            ];
        }
    }

    public function findAllByTaskList(?Request $request)
    {
        try {
            $qb = $this->createQueryBuilder('td')
                ->andWhere('td.taskList = :task_list')
                ->setParameter('task_list', (int) $request->get('task_list'))
            ;
            $paginator = $this->paginator($qb->getQuery(), (int) $request->get('page') > 0 ? (int) $request->get('page') : 1, (int) $request->get('limit') > 0 ? (int) $request->get('limit') : 5);
            return $paginator;
        } catch (\Exception $e) {
            return [
                'status' => 500,
                'message' => $e->getMessage(),
                'trace_as_string' => $e->getTraceAsString(),
            ];
        }
    }

}
