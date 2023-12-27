<?php

namespace Ratipriya\SngineFAQ\Tests;

use PHPUnit\Framework\TestCase;
use Ratipriya\SngineFAQ\SngineFAQ;

final class SngineFAQTest extends TestCase
{
    public function testSngineFAQ(): void 
    {
        $faq = new SngineFAQ("Hi");
        $response = $faq->showText();
        $this->assertEquals(2, strlen($response));
    }
}
