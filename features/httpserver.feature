Feature: Implement an HTTP server
  Background:
    Given port is 5001

  Scenario: Fetch a web page
    Given an HTTP server
    And a file "public/index.html" with
    """
    <html>
    <body>
    hello
    </body>
    </html>
    """
    When I fetch "http://localhost:5001/index.html"
    Then I should see "hello"
    And the return code is 200

  Scenario: Fetch a nonexistant page
    Given an HTTP server
    When I fetch "http://localhost:5001/does-not-exist"
    Then the return code is 404

  Scenario: Fetch a directory
    Given an HTTP server
    When I fetch "http://localhost:5001/"
    Then the return code is 200
    And there is a link to "index.html"

  Scenario:
    If a page causes the application to crash it should
    still be able to handle the next request

    Given an HTTP server
    When I crash the server
    Then the return code is 500
    When I fetch "http://localhost:5001/index.html"
    Then the return code is 200

  Scenario:  Method Not Allowed
    Given an HTTP server
    And I configure deny put "/file1"
    And I configure deny post "/text-file.txt"
    When I put "http://localhost:5001/file1" with
    """
    foo
    """
    Then the return code is 405
    When I post "http://localhost:5001/text-file.txt" with
    """
    a=b
    """
    Then the return code is 405
