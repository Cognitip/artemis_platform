defmodule AtlasWeb.PermissionPageTest do
  use AtlasWeb.ConnCase
  use ExUnit.Case
  use Hound.Helpers

  import Atlas.Factories
  import AtlasWeb.BrowserHelpers
  import AtlasWeb.Router.Helpers

  @moduletag :browser
  @url permission_url(AtlasWeb.Endpoint, :index)

  hound_session()

  describe "authentication" do
    test "requires authentication" do
      navigate_to(@url)

      assert redirected_to_sign_in_page?()
    end
  end

  describe "index" do
    setup do
      browser_sign_in()
      navigate_to(@url)

      {:ok, []}
    end

    test "list of records" do
      assert page_title() == "Atlas"
      assert visible?("Listing Permissions")
    end
  end

  describe "new / create" do
    setup do
      browser_sign_in()
      navigate_to(@url)

      {:ok, []}
    end

    test "submitting an empty form shows an error" do
      click_link("New")
      submit_form("#permission-form")

      assert visible?("can't be blank")
    end

    test "successfully creates a new record" do
      click_link("New")

      fill_inputs(%{
        permission_name: "Test Name",
        permission_slug: "test-slug"
      })

      submit_form("#permission-form")

      assert visible?("Test Name")
      assert visible?("test-slug")
    end
  end

  describe "show" do
    setup do
      permission = insert(:permission)

      browser_sign_in()
      navigate_to(@url <> "?page_size=10000")

      {:ok, permission: permission}
    end

    test "record details", %{permission: permission} do
      click_link(permission.slug)

      assert visible?(permission.name)
      assert visible?(permission.slug)
    end
  end

  describe "edit / update" do
    setup do
      permission = insert(:permission)

      browser_sign_in()
      navigate_to(@url <> "?page_size=10000")

      {:ok, permission: permission}
    end

    test "successfully updates record", %{permission: permission} do
      click_link(permission.slug)
      click_link("Edit")

      fill_inputs(%{
        permission_name: "Updated Name",
        permission_slug: "updated-slug"
      })

      submit_form("#permission-form")

      assert visible?("Updated Name")
      assert visible?("updated-slug")
    end
  end

  describe "delete" do
    setup do
      permission = insert(:permission)

      browser_sign_in()
      navigate_to(@url)

      {:ok, permission: permission}
    end

    @tag :uses_browser_alert_box
    # test "deletes record and redirects to index", %{permission: permission} do
    #   click_link(permission.slug)
    #   click_button("Delete")
    #   accept_dialog()

    #   assert current_url() == @url
    #   assert not visible?(permission.slug)
    # end
  end
end
