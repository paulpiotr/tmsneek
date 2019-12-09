<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\Request;

class DefaultController extends AbstractController
{
    /**
     * @Route(
     *     {
     *     "pl": "/",
     *     "en": "/",
     *     },
     *     name="default_controller_index",
     * )
     *
     * @param Request $request
     * @return Symfony\Component\HttpFoundation\Request
     */
    public function indexAction(Request $request)
    {
        return $this->render('base.html.twig', []);
    }
}