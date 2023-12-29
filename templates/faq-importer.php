<?php

/**
 * update wizard
 * 
 * @package Sngine
 * @author Zamblek
 */

// set execution time
set_time_limit(0); /* unlimited max execution time */

// set ABSPATH & BASEPATH
define('ABSPATH', __DIR__ . '/');
define('BASEPATH', dirname($_SERVER['PHP_SELF']));
require('bootloader.php');
require_once __DIR__ . '/vendor/autoload.php';
use Ratipriya\SngineFAQ\SngineFAQ;

// check config file
if (!file_exists(ABSPATH . 'includes/config.php')) {
    /* the config file doesn't exist -> start the installer */
    header('Location: ./install');
}


// get config file
require(ABSPATH . 'includes/config.php');


// set debugging settings
if (DEBUGGING) {
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);
} else {
    ini_set("display_errors", false);
    error_reporting(0);
}


// get functions
require_once(ABSPATH . 'includes/functions.php');


// update
if (isset($_POST['submit'])) {

    // check purchase code
    try {
        $licence_key = get_licence_key($_POST['purchase_code']);
        if (is_empty($_POST['purchase_code']) || $licence_key === false) {
            _error("Error", "Please enter a valid purchase code");
        }
        $session_hash = $licence_key;
        $JWT_SECRET = md5($licence_key);
        $faq = new SngineFAQ(true, $db);
    } catch (Exception $e) {
        _error("Error", $e->getMessage());
    }

    // finished!
    _error("FAQ Module Imported", "Sngine FAQ Module has been imported successfully");
}

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Import FAQ Module</title>
    <link rel="shortcut icon" href="includes/assets/js/core/installer/favicon.png" />
    <link href="https://fonts.googleapis.com/css?family=Karla:400,700&display=swap" rel="stylesheet" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" integrity="sha512-iecdLmaskl7CVkqkXNQ/ZH/XLlvWZOJyj7Yy7tcenmpD1ypASozpmT/E0iPtmFIB46ZmdtAc9eNBvH0H/ZpiBw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" integrity="sha512-t4GWSVZO1eC8BM339Xd7Uphw5s17a86tIZIj8qRxhnKub6WoyhnrxeCIMeAqBPgdZGlCcG2PrZjMc+Wr78+5Xg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="includes/assets/js/core/installer/wizard.css">
</head>

<body>
    <main class="my-5">
        <div class="container">
            <form id="wizard" method="post" class="position-relative">
                <!-- Step 1 -->
                <h3>
                    <div class="media">
                        <div class="bd-wizard-step-icon"><i class="fas fa-cubes"></i></div>
                        <div class="media-body">
                            <div class="bd-wizard-step-title">FAQ Module</div>
                            <div class="bd-wizard-step-subtitle">Import Sngine FAQ Module</div>
                        </div>
                    </div>
                </h3>
                <section>
                    <div class="content-wrapper">
                        <h3 class="section-heading">Welcome!</h3>
                        <p>
                            Welcome to <strong>Sngine</strong> FAQ Module import process! Just fill in the information below.
                        </p>
                        <div class="row mt-4">
                            <div class="form-group col-12">
                                <label for="purchase_code">Your Purchase Code</label>
                                <input type="text" name="purchase_code" id="purchase_code" class="form-control" placeholder="xxx-xx-xxxx">
                                <div class="invalid-feedback">
                                    This field can't be empty
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- Step 1 -->
                <!-- Submit -->
                <div style="display: none;">
                    <button class="btn btn-primary" name="submit" type="submit" id="wizard-submittion">Submit</button>
                </div>
                <!-- Submit -->
                <!-- Loader -->
                <div id="loader" style="display: none;">
                    <div class="wizard-loader">
                        In Progress<span class="spinner-grow spinner-grow-sm ml-3"></span>
                    </div>
                </div>
                <!-- Loader -->
            </form>
        </div>
    </main>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.min.js" integrity="sha512-3dZ9wIrMMij8rOH7X3kLfXAzwtcHpuYpEgQg1OA4QAob1e81H8ntUQmQm3pBudqIoySO5j0tHN4ENzA6+n2r4w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="includes/assets/js/core/installer/jquery.steps.min.js"></script>
    <script type="text/javascript">
        // handle wizard
        var wizard = $("#wizard");
        wizard.steps({
            headerTag: "h3",
            bodyTag: "section",
            transitionEffect: "none",
            titleTemplate: '#title#',
            onFinished: function(event, currentIndex) {
                /* check details */
                if ($('input[type="text"]').val() == "") {
                    $('input[type="text"]').addClass("is-invalid");
                    return false;
                }
                $("#loader").slideDown();
                $("#wizard-submittion").trigger('click');
                return true;
            },
            labels: {
                finish: "Import",
            }
        });

        // handle inputs
        $('input[type="text"]').on('change', function() {
            if ($(this).val() == "") {
                $(this).addClass("is-invalid");
            } else {
                $(this).removeClass("is-invalid");
            }
        });
    </script>
</body>

</html>