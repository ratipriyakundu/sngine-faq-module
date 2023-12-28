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
    {if $sub_view == "edit"} &rsaquo; {$data['title']}{/if}
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
                        <a data-bs-toggle="tooltip" title='{__("Edit")}' href="{$system['system_url']}/{$control_panel['url']}/languages/edit/{$row['language_id']}" class="btn btn-sm btn-icon btn-rounded btn-primary">
                            <i class="fa fa-pencil-alt"></i>
                        </a>
                        <button data-bs-toggle="tooltip" title='{__("Delete")}' class="btn btn-sm btn-icon btn-rounded btn-danger js_admin-deleter" data-handle="language" data-id="{$row['language_id']}">
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

    <form class="js_ajax-forms" data-url="admin/languages.php?do=edit&id={$data['language_id']}">
      <div class="card-body">
        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Default")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="default">
              <input type="checkbox" name="default" id="default" {if $data['default']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it the default language of the site")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Enabled")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="enabled" id="enabled" {if $data['enabled']}checked{/if}>
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it enbaled so the user can translate the site to it")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Code")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="code" value="{$data['code']}">
            <div class="form-text">
              {__("Language country_code, For Example: en_us, ar_sa or fr_fr")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Native Name")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="title" value="{$data['title']}">
            <div class="form-text">
              {__("The native name of this language")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Flag")}
          </label>
          <div class="col-md-9">
            {if $data['flag'] == ''}
              <div class="x-image">
                <button type="button" class="btn-close x-hidden js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="flag" value="">
              </div>
            {else}
              <div class="x-image" style="background-image: url('{$system['system_uploads']}/{$data['flag']}')">
                <button type="button" class="btn-close js_x-image-remover" title='{__("Remove")}'>

                </button>
                <div class="x-image-loader">
                  <div class="progress x-progress">
                    <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                  </div>
                </div>
                <i class="fa fa-camera fa-lg js_x-uploader" data-handle="x-image"></i>
                <input type="hidden" class="js_x-image-input" name="flag" value="{$data['flag']}">
              </div>
            {/if}
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Direction")}
          </label>
          <div class="col-md-9">
            <select class="form-select" name="dir">
              <option {if $data['dir'] == "LTR"}selected{/if} value="LTR">LTR</option>
              <option {if $data['dir'] == "RTL"}selected{/if} value="RTL">RTL</option>
            </select>
            <div class="form-text">
              {__("The direction of this language 'Left To Right' or 'Right To Left'")}
            </div>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Order")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="language_order" value="{$data['language_order']}">
          </div>
        </div>

        <!-- success -->
        <div class="alert alert-success mt15 mb0 x-hidden"></div>
        <!-- success -->

        <!-- error -->
        <div class="alert alert-danger mt15 mb0 x-hidden"></div>
        <!-- error -->
      </div>
      <div class="card-footer text-end">
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {elseif $sub_view == "add"}

    <form class="js_ajax-forms" data-url="admin/languages.php?do=add">
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
            <input class="form-control" name="page_title">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Page Content")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" rows="5" name="page_content"></textarea>
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("Enabled")}
          </label>
          <div class="col-md-9">
            <label class="switch" for="enabled">
              <input type="checkbox" name="enabled" id="enabled">
              <span class="slider round"></span>
            </label>
            <div class="form-text">
              {__("Make it enabled so the user can see FAQ in this language")}
            </div>
          </div>
        </div>

        <hr>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FAQ Title")}
          </label>
          <div class="col-md-9">
            <input class="form-control" name="faq_title[]">
          </div>
        </div>

        <div class="row form-group">
          <label class="col-md-3 form-label">
            {__("FAQ Content")}
          </label>
          <div class="col-md-9">
            <textarea class="form-control" rows="5" name="faq_content[]"></textarea>
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
            <input class="form-control" name="faq_order[]">
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
        <button type="button" class="btn btn-info">{__("More FAQ")}</button>
        <button type="submit" class="btn btn-primary">{__("Save Changes")}</button>
      </div>
    </form>

  {/if}
</div>