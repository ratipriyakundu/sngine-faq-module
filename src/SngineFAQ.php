<?php

namespace Ratipriya\SngineFAQ;

final class SngineFAQ
{
    private $db;
    private $rootDirectory = '';
    private $importFAQModule = false;

    public function __construct($importFAQModule = false, $db = '')
    {
        if (is_object($db)) {
            $this->db = $db;
        }
        $this->rootDirectory = dirname(dirname(dirname(dirname(__DIR__))));
        $this->importFAQModule = $importFAQModule;
        $this->importFAQModule($this->importFAQModule);
    }

    private function importFAQModule($importFAQModule)
    {
        if ($importFAQModule) {
            //Check if import required for admin.tpl file
            if (
                filesize($this->rootDirectory . '/content/themes/default/templates/admin.tpl')
                !== filesize(dirname(__DIR__) . '/templates/admin.tpl')
                || md5_file($this->rootDirectory . '/content/themes/default/templates/admin.tpl')
                !== md5_file(dirname(__DIR__) . '/templates/admin.tpl')
            ) {
                copy(
                    dirname(__DIR__) . '/templates/admin.tpl',
                    $this->rootDirectory . '/content/themes/default/templates/admin.tpl'
                );
            }

            //Check if import required for admin.php file
            if (
                filesize($this->rootDirectory . '/admin.php')
                !== filesize(dirname(__DIR__) . '/templates/admin.php')
                || md5_file($this->rootDirectory . '/admin.php')
                !== md5_file(dirname(__DIR__) . '/templates/admin.php')
            ) {
                copy(
                    dirname(__DIR__) . '/templates/admin.php',
                    $this->rootDirectory . '/admin.php'
                );
            }

            //Check if import required for admin.faq.tpl file
            if (
                file_exists($this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl')
            ) {
                if (
                    filesize($this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl')
                    !== filesize(dirname(__DIR__) . '/templates/admin.faq.tpl')
                    || md5_file($this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl')
                    !== md5_file(dirname(__DIR__) . '/templates/admin.faq.tpl')
                ) {
                    copy(
                        dirname(__DIR__) . '/templates/admin.faq.tpl',
                        $this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl'
                    );
                }
            } else {
                touch($this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl');
                copy(
                    dirname(__DIR__) . '/templates/admin.faq.tpl',
                    $this->rootDirectory . '/content/themes/default/templates/admin.faq.tpl'
                );
            }

            //Check if import required for delete.php file
            if (
                file_exists($this->rootDirectory . '/includes/ajax/admin/delete.php')
            ) {
                if (
                    filesize($this->rootDirectory . '/includes/ajax/admin/delete.php')
                    !== filesize(dirname(__DIR__) . '/templates/delete.php')
                    || md5_file($this->rootDirectory . '/includes/ajax/admin/delete.php')
                    !== md5_file(dirname(__DIR__) . '/templates/delete.php')
                ) {
                    copy(
                        dirname(__DIR__) . '/templates/delete.php',
                        $this->rootDirectory . '/includes/ajax/admin/delete.php'
                    );
                }
            } else {
                touch($this->rootDirectory . '/includes/ajax/admin/delete.php');
                copy(
                    dirname(__DIR__) . '/templates/delete.php',
                    $this->rootDirectory . '/includes/ajax/admin/delete.php'
                );
            }

            //Check if import required for faq.php file
            if (
                file_exists($this->rootDirectory . '/includes/ajax/admin/faq.php')
            ) {
                if (
                    filesize($this->rootDirectory . '/includes/ajax/admin/faq.php')
                    !== filesize(dirname(__DIR__) . '/templates/faq.php')
                    || md5_file($this->rootDirectory . '/includes/ajax/admin/faq.php')
                    !== md5_file(dirname(__DIR__) . '/templates/faq.php')
                ) {
                    copy(
                        dirname(__DIR__) . '/templates/faq.php',
                        $this->rootDirectory . '/includes/ajax/admin/faq.php'
                    );
                }
            } else {
                touch($this->rootDirectory . '/includes/ajax/admin/faq.php');
                copy(
                    dirname(__DIR__) . '/templates/faq.php',
                    $this->rootDirectory . '/includes/ajax/admin/faq.php'
                );
            }

            //Check 'faqs' table exists in our database or need to import
            $sql = "SHOW TABLES LIKE 'faqs'";
            $query = $this->db->query($sql);
            if ($query->num_rows == 0) {
                $faq_table_sql = "CREATE TABLE `faqs` (
                    `id` int(10) UNSIGNED NOT NULL,
                    `language_id` int(10) UNSIGNED NOT NULL,
                    `language_code` varchar(255) NOT NULL,
                    `page_title` varchar(255) NOT NULL,
                    `page_content` longtext NOT NULL,
                    `faq_enabled` enum('0','1') NOT NULL DEFAULT '1'
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci";
                $this->db->query($faq_table_sql);
                $faq_table_sql = "ALTER TABLE `faqs`
                ADD PRIMARY KEY (`id`),
                ADD KEY `faqs_foreign_language_id` (`language_id`)";
                $this->db->query($faq_table_sql);
                $faq_table_sql = "ALTER TABLE `faqs`
                MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT";
                $this->db->query($faq_table_sql);
                $faq_table_sql = "ALTER TABLE `faqs`
                ADD CONSTRAINT `faqs_foreign_language_id`
                FOREIGN KEY (`language_id`) REFERENCES `system_languages` (`language_id`)
                ON DELETE CASCADE";
                $this->db->query($faq_table_sql);
            }

            //Check 'faq-items' table exists in our database or need to import
            $sql = "SHOW TABLES LIKE 'faq-items'";
            $query = $this->db->query($sql);
            if ($query->num_rows == 0) {
                $faq_item_table_sql = "CREATE TABLE `faq-items` (
                    `id` int(10) UNSIGNED NOT NULL,
                    `faq_id` int(10) UNSIGNED NOT NULL,
                    `faq_title` varchar(255) NOT NULL,
                    `faq_content` longtext NOT NULL,
                    `content_online` enum('0','1') NOT NULL DEFAULT '1',
                    `faq_order` int(10) NOT NULL DEFAULT '0'
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci";
                $this->db->query($faq_item_table_sql);
                $faq_item_table_sql = "ALTER TABLE `faq-items`
                ADD PRIMARY KEY (`id`),
                ADD KEY `faq-items_foreign_faq_id` (`faq_id`)";
                $this->db->query($faq_item_table_sql);
                $faq_item_table_sql = "ALTER TABLE `faq-items`
                MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT";
                $this->db->query($faq_item_table_sql);
                $faq_item_table_sql = "ALTER TABLE `faq-items`
                ADD CONSTRAINT `faq-items_foreign_faq_id` FOREIGN KEY (`faq_id`) REFERENCES `faqs` (`id`)
                ON DELETE CASCADE";
                $this->db->query($faq_item_table_sql);
            }
        }
    }
}
