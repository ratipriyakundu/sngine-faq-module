<div class="card">
  <div class="card-header with-icon d-flex justify-content-between">
    {if $sub_view == ""}
    {elseif $sub_view == "add" || $sub_view == "edit"}
      <div class="float-end">
        <a href="{$system['system_url']}/{$control_panel['url']}/faq" class="btn btn-md btn-light">
          <i class="fa fa-arrow-circle-left mr5"></i>{__("Go Back")}
        </a>
      </div>
    {/if}
    {__("FAQ Pages")}
    {if $sub_view == "edit"} &rsaquo; {__("Edit FAQ")}{/if}
    {if $sub_view == "add"} &rsaquo; {__("Add New FAQ Page")}{/if}
  </div>

  {if $sub_view == ""}

    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover js_dataTable">
          <thead>
            <tr>
              <th>{__("ID")}</th>
              <th>{__("Language")}</th>
              <th>{__("Code")}</th>
              <th>{__("Enabled")}</th>
              <th>{__("Actions")}</th>
            </tr>
          </thead>
          <tbody>
            {foreach $rows as $row}
              <tr>
                <td>{$row['language_id']}</td>
                <td>
                  <a href="{$system['system_url']}/{$control_panel['url']}/languages/edit/{$row['language_id']}">
                    <img class="tbl-image" src="{$row['flag']}">
                    {$row['title']}
                  </a>
                </td>
                <td>{$row['code']}</td>
                <td>
                    {if $row['faq_enabled']}
                        <span class="badge rounded-pill badge-lg bg-success">{__("Yes")}</span>
                    {else}
                        <span class="badge rounded-pill badge-lg bg-danger">{__("No")}</span>
                    {/if}
                </td>
                <td>
                    {if $row['faq_exists']}
                        <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/faq/edit/{$row['language_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                            <i class="fa fa-pencil-alt"></i>
                        </a>
                        <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="faq" data-id="{$row['language_id']}">
                            <i class="fa fa-trash-alt"></i>
                        </button>
                    {else}
                        <a data-bs-toggle="tooltip" title='{__("Add")}' href="{$system['system_url']}/{$control_panel['url']}/faq/add/{$row['language_id']}" class="btn btn-sm btn-icon btn-primary">
                            <i class="fa fa-plus-circle"></i> Add FAQ
                        </a>
                    {/if}
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    </div>

  {elseif $sub_view == "edit"}

    <form class="js_ajax-forms" data-url="admin/faq.php?do=edit&id={$data['id']}">
      <div class="card-body">
        <input type="hidden" name="faq_id" value="{$data['id']}">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Web Address")}
          </label>
          <div class="col-md-9">
            <div class="input-group">
              <div class="input-group-text text-end w-100 d-none d-sm-block">{$system['system_url']}/faq/{$data['language_code']}</div>
            </div>
            <div class="form-text">
              {__("Valid web address must be a-z0-9_.")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" value="{$data['page_title']}" name="page_title" autocomplete="off">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Content")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control js_wysiwyg-advanced" rows="5" name="page_content">{$data['page_content']}</textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Enabled")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="faq_enabled" id="enabled" {$data['faq_enabled'] == 1 } ? checked : ''>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it enabled so the user can see FAQ in this language")}
            </div>
          </div>
        </div>


        {foreach $data['items'] as $index => $row}
          <div class="faq-item col-md-12">
          <hr>
            <input type="hidden" name="item_id[]" value="{$row['id']}">
            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("FAQ Title")}
              </label>
              <div class="col-md-9">
                <input class="form-control" value="{$row['faq_title']}" name="edit_faq_title[]" autocomplete="off">
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("FAQ Content")}
              </label>
              <div class="col-md-9">
                <textarea class="form-control js_wysiwyg-advanced" rows="5" name="edit_faq_content[]">{$row['faq_content']}</textarea>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("FAQ Content Online")}
              </label>
              <div class="col-md-9">
                <label class="switch">
                  <input type="checkbox" name="edit_content_online[]" {$row['content_online']} ? checked : ''>
                  <span class="slider round"></span>
                </label>
                <div class="form-text">
                  {__("Make it enabled so the user can see FAQ in this language")}
                </div>
              </div>
            </div>

            <div class="row form-group">
              <label class="col-md-3 form-label">
                {__("Order")}
              </label>
              {if $index == 0}
                <div class="col-md-9">
                  <input class="form-control" name="edit_faq_order[]" value="{$row['faq_order']}" autocomplete="off">
                </div>
              {else}
                <div class="col-md-6">
                  <input class="form-control" name="edit_faq_order[]" value="{$row['faq_order']}" autocomplete="off">
                </div>
                <div class="col-md-3">
                  <button type="button" onclick="removeFAQ(this)" class="btn btn-sm py-3 btn-danger">{__("DELETE FAQ")}</button>
                </div>
              {/if}
            </div>
          </div>
        {/foreach}

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-start">
        <button type="button" onclick="addMoreFAQ()" class="btn btn-info">{__("More FAQ")}</button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/faq.php?do=add">
      <div class="card-body">
        <input type="hidden" name="language_id" value="{$data['language_id']}">
        <input type="hidden" name="language_code" value="{$data['code']}">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Web Address")}
          </label>
          <div class="col-md-9">
            <div class="input-group">
              <div class="input-group-text text-end w-100 d-none d-sm-block">{$system['system_url']}/faq/{$data['code']}</div>
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="page_title" autocomplete="off">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Content")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control js_wysiwyg-advanced" rows="5" name="page_content"></textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Enabled")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="faq_enabled" id="enabled">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it enabled so the user can see FAQ in this language")}
            </div>
          </div>
        </div>

        <hr>

        <div class="faq-item col-md-12">

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("FAQ Title")}
            </label>
            <div class="col-md-9">
              <input class="form-control" name="faq_title[]" autocomplete="off">
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("FAQ Content")}
            </label>
            <div class="col-md-9">
              <textarea class="form-control js_wysiwyg-advanced" rows="5" name="faq_content[]"></textarea>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("FAQ Content Online")}
            </label>
            <div class="col-md-9">
              <label class="switch">
                <input type="checkbox" name="content_online[]">
                <span class="slider round"></span>
              </label>
              <div class="form-text">
                {__("Make it enabled so the user can see FAQ in this language")}
              </div>
            </div>
          </div>

          <div class="row form-group">
            <label class="col-md-3 form-label">
              {__("Order")}
            </label>
            <div class="col-md-9">
              <input class="form-control" name="faq_order[]" autocomplete="off">
            </div>
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-start">
        <button type="button" onclick="addMoreFAQ()" class="btn btn-info">{__("More FAQ")}</button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {/if}
</div>
<script>
function addMoreFAQ() {
    let faq_template = 
    '<div class="faq-item col-md-12">\
    <hr>\
        <div class="row form-group">\
        <label class="col-md-3 form-label">\
            {__("FAQ Title")}\
        </label>\
        <div class="col-md-9">\
            <input class="form-control" name="faq_title[]" autocomplete="off">\
        </div>\
        </div>\
        <div class="row form-group">\
        <label class="col-md-3 form-label">\
            {__("FAQ Content")}\
        </label>\
        <div class="col-md-9">\
            <textarea class="form-control js_wysiwyg-advanced" rows="5" name="faq_content[]"></textarea>\
        </div>\
        </div>\
        <div class="row form-group">\
        <label class="col-md-3 form-label">\
            {__("FAQ Content Online")}\
        </label>\
        <div class="col-md-9">\
            <label class="switch">\
            <input type="checkbox" name="content_online[]">\
            <span class="slider round"></span>\
            </label>\
            <div class="form-text">\
            {__("Make it enabled so the user can see FAQ in this language")}\
            </div>\
        </div>\
        </div>\
        <div class="row form-group">\
        <label class="col-md-3 form-label">\
            {__("Order")}\
        </label>\
        <div class="col-md-6">\
            <input class="form-control" name="faq_order[]" autocomplete="off">\
        </div>\
        <div class="col-md-3">\
            <button type="button" onclick="removeFAQ(this)" class="btn btn-sm py-3 btn-danger">{__("DELETE FAQ")}</button>\
        </div>\
        </div>\
    </div>';
    $('.faq-item:last').after(faq_template);
}
function removeFAQ(el) {
  $(el).parent().parent().closest('.faq-item').remove();
}
</script>