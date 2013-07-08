Feature: Implement an HTTP server
  Scenario: Fetch a web page
    Given an HTTP server on port 5000
    And a file "public/index.html" with
    """
    <html>
    <body>
    hello
    </body>
    </html>
    """
    When I fetch "http://localhost:5000/"
    Then I should see "hello"
