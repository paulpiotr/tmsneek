<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;
use App\Entity\TaskDetails;

class TaskDetailsController extends AbstractController
{
    /**
     * @Route(
     *     {
     *     "pl": "/szczegoly_zadania/indeks/{task_list}",
     *     "en": "/task_details/index/{task_list}",
     *     },
     *     name="task_details_controller_index",
     *     defaults={
     *     "task_list": null,
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
        $data = $this->get('doctrine')->getRepository(TaskDetails::class)->findAllByTaskList($request);
        return $this->render('task_details/index.html.twig', [
            'data' => $data,
        ]);
    }

}
