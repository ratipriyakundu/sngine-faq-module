<?php

/**
 * ajax -> admin -> static
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle static
try {

  switch ($_GET['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }

      $check_faq = $db->query(sprintf("SELECT * FROM faqs WHERE id = %s", secure($_GET['id'], 'int'))) or _error('SQL_ERROR_THROWEN');
      if ($check_faq->num_rows == 0) {
        throw new Exception(__("FAQ not exists"));
      }

      /* valid inputs */
      if (is_empty($_POST['faq_id'])) {
        throw new Exception(__("FAQ Id is Missing"));
      }
      if (is_empty($_POST['page_title'])) {
        throw new Exception(__("Please enter page title"));
      }
      if (is_empty($_POST['page_content'])) {
        throw new Exception(__("Please enter page content"));
      }
      /* enabled or not */
      $_POST['faq_enabled'] = (isset($_POST['faq_enabled'])) ? '1' : '0';

      foreach ($_POST['item_id'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Invalid FAQ Item Id"));
        }
      }

      foreach ($_POST['edit_faq_title'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ title"));
        }
      }
      foreach ($_POST['edit_faq_content'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ content"));
        }
      }
      foreach ($_POST['edit_faq_order'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ order"));
        }
      }

      foreach ($_POST['faq_title'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ title"));
        }
      }
      foreach ($_POST['faq_content'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ content"));
        }
      }
      foreach ($_POST['faq_order'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ order"));
        }
      }

      /* update */
      $db->query(sprintf("UPDATE faqs SET page_title = %s, page_content = %s, faq_enabled = %s WHERE id = %s", secure($_POST['page_title']), secure($_POST['page_content']), secure($_POST['faq_enabled']), secure($_GET['id'], 'int'))) or _error('SQL_ERROR_THROWEN');
      for ($i=0; $i < count($_POST['item_id']); $i++) { 
        $db->query(sprintf("UPDATE `faq-items` SET faq_title = %s, faq_content = %s, content_online = %s, faq_order = %s WHERE id = %s", secure($_POST['edit_faq_title'][$i]), secure($_POST['edit_faq_content'][$i]), secure($_POST['edit_content_online'][$i] ? 1 : 0), secure($_POST['edit_faq_order'][$i]), secure($_POST['item_id'][$i], 'int'))) or _error('SQL_ERROR_THROWEN');
      }
      $faq_items = $db->query(sprintf("SELECT * FROM `faq-items` WHERE faq_id = %s", secure($_GET['id'], 'int'))) or _error('SQL_ERROR');
      foreach ($faq_items as $faq_item) {
        if(!(in_array($faq_item['id'],$_POST['item_id']))) {
          $db->query(sprintf("DELETE FROM `faq-items` WHERE id = %s", secure($faq_item['id'], 'int'))) or _error('SQL_ERROR');
        }
      }
      if(isset($_REQUEST['faq_title'])) {
        for ($i = 0; $i < count($_POST['faq_title']); $i++) {
          $db->query(sprintf("INSERT INTO `faq-items` (faq_id, faq_title, faq_content, content_online, faq_order) VALUES (%s, %s, %s, %s, %s)", secure($_GET['id'],'int'), secure($_POST['faq_title'][$i]), secure($_POST['faq_content'][$i]), secure((isset($_POST['content_online'][$i])) ? '1' : '0'), secure($_POST['faq_order'][$i], 'int'))) or _error('SQL_ERROR_THROWEN');
        }
      }
      /* return */
      return_json(array('success' => true, 'message' => __("FAQ has been updated")));
      break;

    case 'add':

      /* valid inputs */
      if (is_empty($_POST['language_id'])) {
        throw new Exception(__("Language Id is Missing"));
      }
      if (is_empty($_POST['language_code'])) {
        throw new Exception(__("Language Code is Missing"));
      }
      if (is_empty($_POST['page_title'])) {
        throw new Exception(__("Please enter page title"));
      }
      if (is_empty($_POST['page_content'])) {
        throw new Exception(__("Please enter page content"));
      }
      /* enabled or not */
      $_POST['faq_enabled'] = (isset($_POST['faq_enabled'])) ? '1' : '0';

      foreach ($_POST['faq_title'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ title"));
        }
      }
      foreach ($_POST['faq_content'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ content"));
        }
      }
      foreach ($_POST['faq_order'] as $key => $value) {
        if (empty($value)) {
          throw new Exception(__("Please enter FAQ order"));
        }
      }

      /* insert FAQ and FAQ Items */
      if ($db->query(sprintf("INSERT INTO faqs (language_id, language_code, page_title, page_content, faq_enabled) VALUES (%s, %s, %s, %s, %s)", secure($_POST['language_id']), secure($_POST['language_code']), secure($_POST['page_title']), secure($_POST['page_content']), secure($_POST['faq_enabled'], 'int'))) === true) {
        $faq_id = $db->insert_id;
        for ($i = 0; $i < count($_POST['faq_title']); $i++) {
          $db->query(sprintf("INSERT INTO `faq-items` (faq_id, faq_title, faq_content, content_online, faq_order) VALUES (%s, %s, %s, %s, %s)", secure($faq_id), secure($_POST['faq_title'][$i]), secure($_POST['faq_content'][$i]), secure((isset($_POST['content_online'][$i])) ? '1' : '0'), secure($_POST['faq_order'][$i], 'int'))) or _error('SQL_ERROR_THROWEN');
        }
      } else {
        throw new Exception(__("Something went wrong"));
      }
      /* return */
      return_json(array('callback' => 'window.location = "' . $system['system_url'] . '/' . $control_panel['url'] . '/faq";'));
      break;

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(array('error' => true, 'message' => $e->getMessage()));
}
