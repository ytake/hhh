namespace Hhh;

use type Hhh\Exception\IOErrorException;
use namespace HH\Lib\Str;
use function min;

class RingBuffer {

  public bool $eof = false;
  protected string $readBuf = '';
  protected string $writeBuf = '';

  public function __construct(
    public resource $sock
  ) {}

  public function read(
    int $nbytes,
    bool $buffered = false
  ): string {
    $nbytesConsumerFromBuffer = min($nbytes, Str\length($this->readBuf));
    $retval = Str\slice($this->readBuf, 0, $nbytes);
    $this->readBuf = Str\slice($this->readBuf, $nbytes);
    $nbytes -= $nbytesConsumerFromBuffer;

    if (!$buffered && Str\length($this->readBuf) < $nbytes) {
      $chunk = \fread($this->sock, $nbytes);
      if ($chunk === false) {
        throw new IOErrorException();
      }
      if ($chunk == '') {
        $this->eof = true;
      }
      $retval = $this->readBuf;
      $retval .= $chunk;
      $this->readBuf = '';
    }
    return $retval;
  }

  public function unread(
    string $data
  ): void {
    $this->readBuf .= $data;
  }

  public async function writeAsync(
    string $data = ''
  ): Awaitable<int> {
    if ($this->writeBuf == '') {
      $this->writeBuf = $data;
    }
    if (Str\length($this->writeBuf) == 0) {
      return 0;
    }
    $nbytes = \fwrite($this->sock, $this->writeBuf);
    if ($nbytes === false) {
      throw new IOErrorException();
    }
    $this->writeBuf = Str\slice($this->writeBuf, $nbytes);
    return $nbytes;
  }
}
