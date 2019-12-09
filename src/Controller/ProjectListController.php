<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

use App\Entity\ProjectList;

class ProjectListController extends AbstractController
{
    /**
     * @Route(
     *     {
     *     "pl": "/lista_projektow/indeks/{page}/{limit}",
     *     "en": "/project_list/index/{page}/{limit}",
     *     },
     *     name="project_list_controller_index",
     *     defaults={
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
        $data = $this->get('doctrine')->getRepository(ProjectList::class)->findByAll($request);
        return $this->render('project_list/index.html.twig', [
            'data' => $data,
        ]);
    }

    /**
     * @Route(
     *     {
     *     "pl": "/lista_projektow/szukaj/{page}/{limit}",
     *     "en": "/project_list/search/{page}/{limit}",
     *     },
     *     name="project_list_controller_search",
     *     defaults={
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
        $data = $this->get('doctrine')->getRepository(ProjectList::class)->findByHightPriority($request);
        return $this->render('project_list/search.html.twig', [
            'data' => $data,
        ]);
    }

}