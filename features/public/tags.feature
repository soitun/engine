Feature: Tagged content
  As a designer
  In order to organize my content
  I want to be able to tag it

Background:
  Given I have the site: "test site" set up
  And I have a custom model named "Posts" with
    | label         | type      | required    |
    | Title         | string    | true        |
    | Body          | string    | false       |
    | Tags          | tags      | false       |
  And I have entries for "Posts" with
    | title             | body          | tags              |
    | Fashion post      | Fashion body  | blogging, fashion |
    | Diet post         | Diet body     | blogging, diet    |

Scenario: Navigate by tags
  Given a page named "my-posts" with the template:
    """
    {% if params.tag %}
      {% with_scope tags: params.tag %}
        {% for post in contents.posts %}
          {{ post.title }}<br>
          {% for tag in post.tags %}
          <a href="/my-posts?tag={{ tag }}">{{ tag }}</a>
          {% endfor %}
          <hr>
        {% endfor %}
      {% endwith_scope %}
    {% else %}
      {% for post in contents.posts %}
        {{ post.title }}<br>
        {% for tag in post.tags %}
        <a href="/my-posts?tag={{ tag }}">{{ tag }}</a>
        {% endfor %}
        <hr>
      {% endfor %}
    {% endif %}
    """
  When I view the rendered page at "/my-posts"
  Then I should see "Fashion post"
  And I should see "Diet post"
  When I follow "blogging"
  Then I should see "Fashion post"
  And I should see "Diet post"
  When I follow "fashion"
  Then I should see "Fashion"
  And I should not see "Diet"