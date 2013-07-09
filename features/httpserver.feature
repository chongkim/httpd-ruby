Feature: Implement an HTTP server
  Scenario: Fetch a web page
    Given an HTTP server on port 5001
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
    Given an HTTP server on port 5001
    When I fetch "http://localhost:5001/does-not-exist"
    Then the return code is 404
