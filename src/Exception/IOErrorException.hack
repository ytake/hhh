namespace Hhh\Exception;

final class IOErrorException extends \Exception {

  public function __construct(
    protected string $message = '',
    int $code = 0,
  ) {
    parent::__construct($message, $code);
  }
}
