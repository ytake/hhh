use type Hhh\RingBuffer;
use type Facebook\HackTest\HackTest;
use namespace HH\Lib\IO;
use function Facebook\FBExpect\expect;

final class RingBufferTest extends HackTest {

  public async function testShouldReturnStringByte(): Awaitable<void> {
    $fiveMBs = 5 * 1024 * 1024;
    $fp = \fopen("php://temp/maxmemory:$fiveMBs", 'w');
    $buff = new RingBuffer($fp);
    $byte = await $buff->writeAsync('hello');
    expect($byte)->toBeSame(5);
    $buff->unread('world');
    expect($buff->read(5))->toBeSame('world');
  }
}
