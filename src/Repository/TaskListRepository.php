<?php

namespace App\Repository;

use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\ORM\Tools\Pagination\Paginator;
use Doctrine\Common\Persistence\ManagerRegistry;
use App\Entity\TaskList;
use Symfony\Component\HttpFoundation\Request;

class TaskListRepository extends ServiceEntityRepository
{

    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, TaskList::class);
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

    public function findAllByProjectList(?Request $request)
    {
        try {
            $qb = $this->createQueryBuilder('tl')
                ->andWhere('tl.projectList=:project_list')
                ->setParameter('project_list', (int) $request->get('project_list'))
                ->innerJoin('App\Entity\Status', 's', 'WITH', 'tl.status=s.id')
                ->addOrderBy('s.priority')
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

    public function findAllByRealizationAndDate(?Request $request)
    {
        try {
            $qb = $this->createQueryBuilder('tl')
                ->innerJoin('App\Entity\ProjectList', 'pl', 'WITH', 'tl.projectList=pl.id')
                ->innerJoin('App\Entity\Status', 's', 'WITH', 'tl.status=s.id')
                ->andWhere('pl.percentage > :percentage')
                ->setParameter('percentage', (int) $request->get('percentage'))
                ->andWhere('tl.creationDate BETWEEN :date_from AND :date_to')
                ->setParameter('date_from', date_create()->modify('-'.(int)$request->get('months').' months')->format('Y-m-d H:i:s'))
                ->setParameter('date_to', date_create()->format('Y-m-d H:i:s'))
                ->addOrderBy('s.priority')
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