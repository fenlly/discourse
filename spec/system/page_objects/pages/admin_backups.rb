# frozen_string_literal: true

module PageObjects
  module Pages
    class AdminBackups < AdminBase
      def visit_page
        page.visit "/admin/backups"
        self
      end

      def has_backup_listed?(filename)
        page.has_css?(backup_row_selector(filename))
      end

      def has_no_backup_listed?(filename)
        page.has_no_css?(backup_row_selector(filename))
      end

      def open_upload_backup_modal
        find(".admin-backups__start").click
      end

      def download_backup(filename)
        find_backup_row(filename).find(row_button_selector("download")).click
      end

      def expand_backup_row_menu(filename)
        find_backup_row(filename).find(".backup-item-menu-trigger").click
      end

      def delete_backup(filename)
        expand_backup_row_menu(filename)
        find(".backup-item-menu-content").find(row_button_selector("delete")).click
      end

      def restore_backup(filename)
        expand_backup_row_menu(filename)
        find(".backup-item-menu-content").find(row_button_selector("restore")).click
      end

      def find_backup_row(filename)
        find(backup_row_selector(filename))
      end

      def backup_row_selector(filename)
        ".admin-backups-list .backup-item-row[data-backup-filename='#{filename}']"
      end

      def row_button_selector(button_name)
        ".backup-item-row__#{button_name}"
      end

      def toggle_read_only
        find(".admin-backups__toggle-read-only").click
      end

      def has_no_read_only_button?
        page.has_no_css?(".admin-backups__toggle-read-only")
      end

      def has_no_backup_button?
        page.has_no_css?(".admin-backups__start")
      end

      def has_no_backup_item_more_menu?
        page.has_no_css?(".backup-item-menu-trigger")
      end
    end
  end
end
