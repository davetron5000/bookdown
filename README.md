# Bookdown - make a technical book in markdown with "live" code examples

When writing technical books or documents, there is always a challenge in keeping the text updated with the
example code.  In an ideal world, your code is 100% executable and working in the way your writing says it
is.

Bookdown is an attempt to remedy that.

You author your text in markdown that has been augmented with special pre-processor tags.  These tags can
run commands, create & edit files, and even do limited stuff in the browser.

## Make a book

```
> bookdown my-book
«bunch of stuff happens»
> cd my-book
> bundle install
> rake
> open site/index.html
```

## Example

Suppose you want to teach someone about the `<h1>` tag. You might write this:


```
The <h1> tag sets text as the top-level heading.

To see it in action, let's create a place to work

!SH mkdir html

Now, create a simple HTML page:

!CREATE_FILE html/index.html
<!DOCTYPE html>
<html>
  <head><title>My Page!</title></head>
  <body>
    This is my page
  </body>
</html>
!END CREATE_FILE

To set “This is my page” as your header, wrap it in `<h1>` tags:

!EDIT_FILE html/index.html <!-- -->
{
  "match": "    This is my page",
  "replace_with": [
    "    <h1>",
    "      This is my page",
    "    </h1>"
  ]
}
!END EDIT_FILE

And now, it's rendered as a header:

!SCREENSHOT "A wild header appears" html/index.html header.png
```

Bookdown converts the above markdown into standard markdown by processing the directives that start with a
`!`.  The result can then be rendered into HTML for viewing on a page.


