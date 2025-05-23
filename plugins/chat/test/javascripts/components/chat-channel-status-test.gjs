import { getOwner } from "@ember/owner";
import { render } from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import { i18n } from "discourse-i18n";
import ChatChannelStatus from "discourse/plugins/chat/discourse/components/chat-channel-status";
import ChatFabricators from "discourse/plugins/chat/discourse/lib/fabricators";
import {
  CHANNEL_STATUSES,
  channelStatusIcon,
} from "discourse/plugins/chat/discourse/models/chat-channel";

module("Discourse Chat | Component | chat-channel-status", function (hooks) {
  setupRenderingTest(hooks);

  test("renders nothing when channel is opened", async function (assert) {
    const self = this;

    this.channel = new ChatFabricators(getOwner(this)).channel();

    await render(
      <template><ChatChannelStatus @channel={{self.channel}} /></template>
    );

    assert.dom(".chat-channel-status").doesNotExist();
  });

  test("defaults to long format", async function (assert) {
    const self = this;

    this.channel = new ChatFabricators(getOwner(this)).channel({
      status: CHANNEL_STATUSES.closed,
    });

    await render(
      <template><ChatChannelStatus @channel={{self.channel}} /></template>
    );

    assert
      .dom(".chat-channel-status")
      .hasText(i18n("chat.channel_status.closed_header"));
  });

  test("accepts a format argument", async function (assert) {
    const self = this;

    this.channel = new ChatFabricators(getOwner(this)).channel({
      status: CHANNEL_STATUSES.archived,
    });

    await render(
      <template>
        <ChatChannelStatus @channel={{self.channel}} @format="short" />
      </template>
    );

    assert
      .dom(".chat-channel-status")
      .hasText(i18n("chat.channel_status.archived"));
  });

  test("renders the correct icon", async function (assert) {
    const self = this;

    this.channel = new ChatFabricators(getOwner(this)).channel({
      status: CHANNEL_STATUSES.archived,
    });

    await render(
      <template><ChatChannelStatus @channel={{self.channel}} /></template>
    );

    assert.dom(`.d-icon-${channelStatusIcon(this.channel.status)}`).exists();
  });

  test("renders archive status", async function (assert) {
    const self = this;

    this.currentUser.admin = true;
    this.channel = new ChatFabricators(getOwner(this)).channel({
      status: CHANNEL_STATUSES.archived,
      archive_failed: true,
    });

    await render(
      <template><ChatChannelStatus @channel={{self.channel}} /></template>
    );

    assert.dom(".chat-channel-retry-archive").exists();
  });
});
