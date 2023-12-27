<?php

namespace Ratipriya\SngineFAQ;

final class SngineFAQ
{
    private $msg;

    public function __construct($msg = "")
    {
        $this->msg = $msg;
    }

    public function showText()
    {
        return $this->msg;
    }
}
