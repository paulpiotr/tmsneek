<?php

namespace App\Controller;

use App\Entity\TaskList;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

class TaskListController extends AbstractController
{
    /**
     * @Route(
     *     {
     *     "pl": "/lista_zadan/indeks/{project_list}",
     *     "en": "/task_list/index/{project_list}",
     *     },
     *     name="task_list_controller_index",
     *     defaults={
     *     "project_list": null,
     *     "page": 1,
     *     "limit": 10,
     *     }
     * )
     *
     * @param Request $request
     * @return Symfony\Component\HttpFoundation\Request
     */
    public function indexAction(Request $request)
    {
        $data = $this->get('doctrine')->getRepository(TaskList::class)->findAllByProjectList($request);
        return $this->render('task_list/index.html.twig', [
            'data' => $data,
        ]);
    }

    /**
     * @Route(
     *     {
     *     "pl": "/lista_zadan/szukaj/{percentage}/{months}",
     *     "en": "/task_list/search/{percentage}/{months}"
     *     },
     *     name="task_list_controller_search",
     *     defaults={
     *     "percentage": 0,
     *     "months": 1,
     *     "page": 1,
     *     "limit": 10,
     *     }
     * )
     *
     * @param Request $request
     * @return Symfony\Component\HttpFoundation\Request
     */
    public function searchAction(Request $request)
    {
        $data = $this->get('doctrine')->getRepository(TaskList::class)->findAllByRealizationAndDate($request);
        return $this->render('task_list/search.html.twig', [
            'data' => $data,
        ]);
    }

}
