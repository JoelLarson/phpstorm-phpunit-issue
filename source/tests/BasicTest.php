<?php

declare(strict_types=1);

namespace Tests;

use App\Basic;
use PHPUnit\Framework\TestCase;

/**
 * Class BasicTest
 * @package Tests
 * @coversDefaultClass \App\Basic
 */
class BasicTest extends TestCase
{
    /**
     * @covers ::getTrue
     */
    public function testBasic()
    {
        $basic = new Basic();

        $this->assertTrue($basic->getTrue());
    }
}