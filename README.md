# Sngine FAQ Module

Multilingual FAQ Module for Sngine Social Network Platform

## Installation

```bash
composer require ratipriya/sngine-faq-module
```

## Usage
Create a new file in your project root with the name faq-import.php and paste the below code in faq-import.php and go to your-site-link/faq-import.php.
```php
<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require('bootloader.php');
require_once __DIR__.'/vendor/autoload.php';

use Ratipriya\SngineFAQ\SngineFAQ;

$faq = new SngineFAQ(true,$db);

?>

```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)