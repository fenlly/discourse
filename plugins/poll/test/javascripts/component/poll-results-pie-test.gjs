import { render } from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import PollResultsPie from "discourse/plugins/poll/discourse/components/poll-results-pie";

const OPTIONS = [
  { id: "1ddc47be0d2315b9711ee8526ca9d83f", html: "This", votes: 3, rank: 0 },
  { id: "70e743697dac09483d7b824eaadb91e1", html: "That", votes: 1, rank: 0 },
  { id: "6c986ebcde3d5822a6e91a695c388094", html: "Other", votes: 2, rank: 0 },
];

const ID = "23";

module("Poll | Component | poll-results-pie", function (hooks) {
  setupRenderingTest(hooks);

  test("Renders the pie chart Component correctly", async function (assert) {
    const self = this;

    this.setProperties({
      id: ID,
      options: OPTIONS,
    });

    await render(
      <template>
        <PollResultsPie @id={{self.id}} @options={{self.options}} />
      </template>
    );

    assert.dom("li.legend").exists({ count: 3 });
    assert.dom("canvas.poll-results-canvas").exists({ count: 1 });
  });
});
