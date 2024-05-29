import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { concat } from "@ember/helper";
import { inject as service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import replaceEmoji from "discourse/helpers/replace-emoji";
import { defaultHomepage } from "discourse/lib/utilities";
import htmlSafe from "discourse-common/helpers/html-safe";

export default class BannerFeaturedLinks extends Component {
  @service router;
  @service siteSettings;
  @tracked featuredLinks = settings.links;

  get showOnRoute() {
    const currentRoute = this.router.currentRouteName;
    switch (settings.show_on) {
      case "everywhere":
        return !currentRoute.includes("admin");
      case "homepage":
        return currentRoute === `discovery.${defaultHomepage()}`;
      case "top-menu":
        const topMenu = this.siteSettings.top_menu;
        const targets = topMenu.split("|").map((opt) => `discovery.${opt}`);
        return targets.includes(currentRoute);
      case "latest":
        return currentRoute === `discovery.latest`;
      case "categories":
        return currentRoute === `discovery.categories`;
      case "top":
        return currentRoute === `discovery.top`;
      default:
        return false;
    }
  }

  <template>
    {{#if this.showOnRoute}}
      <div class="banner-featured-links__wrapper {{settings.plugin_outlet}}">
        <div class="banner-featured-links__wrapper-links">
          {{#each this.featuredLinks as |link index|}}
            <a
              class={{concatClass
                "banner-featured-links__link"
                (concat "bfl-link-" index)
                (if link.button_identifier link.button_identifier)
              }}
              href="{{link.url}}"
              target="{{link.target}}"
              alt="{{htmlSafe link.text}}"
            >
              {{#if link.emoji}}
                {{replaceEmoji link.emoji}}
              {{/if}}
              {{htmlSafe link.text}}
            </a>
          {{/each}}
        </div>
      </div>
    {{/if}}
  </template>
}
