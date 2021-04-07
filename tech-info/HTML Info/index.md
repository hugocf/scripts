# HTML Info

*(alphabetical order)*

[TOC]

## abbreviation

```html
<abbr title="title">abbreviation</abbr>
```



## anchor / link

```html
<a href="">hyperlink</a>
```



## blockquote

- [`<q>`: The Inline Quotation element - HTML: HyperText Markup Language | MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/q#specifications)
- [`<blockquote>`: The Block Quotation element - HTML: HyperText Markup Language | MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote#specifications)
- [`<cite>`: The Citation element - HTML: HyperText Markup Language | MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/cite#specifications)
  - <q>… for screen readers</q>

*… inline*

```html
Inline <q>simple quote</q>.
Inline <q cite="http://example.com">quote with citation</q>.
```

*… simple*

```html
<blockquote>
  <p>Simple quote.</p>
</blockquote>
```

*… with citation*

```html
<blockquote>
  <p>Quote with citation.</p>
  <footer>— <cite class="author">Author</cite> (in <cite class="title">Source</cite>)</footer>
</blockquote>
```

*… in Markdown, via [StackOverflow](https://stackoverflow.com/a/2002150)*

```markdown
> Quote with citation.
> 
> — <cite>Author</cite> in <cite>[Source](http://example.com)</cite>
```



## citation

```html
<cite>person or title</cite>
```



## code

```html
<code>computer code</code>
```



## definition

```html
<dfn title="explanation">term</dfn>
```



## delete

```html
<del>deleted text</del>
```



## details

```html
<details>
  <summary>Collapsed title</summary>
  <p>Content</p>
</details>
```



## emphasis

```html
<em>emphatic text</em>
```



## figure

> The `img` tag is used to embed the image in an HTML document whereas the `figure` tag is used to semantically organize the content of an image in the HTML document.
>
> — [HTML5 - When to use figure tag - Learning Journal](https://www.learningjournal.guru/article/html5/html5-when-to-use-figure-tag/)

```html
<figure>
  <img src="http://placehold.it/100x100.png" alt="image description">
  <figcaption>Image caption</figcaption>
</figure>
```



## footnote

```html
<sup>1</sup>
```

```html
<small><sup>1</sup> footnote</small>
```



## heading / titles

> `h1`–`h6` elements **must not** be used to markup subheadings, subtitles, alternative titles and taglines unless intended to be the heading for a new section or subsection.
>
> — [How to mark up subheadings, subtitles, alternative titles and taglines | HTML5 Doctor](http://html5doctor.com/howto-subheadings/)

```html
<header>
   <h2>Title</h2>
   <p>Tagline or subtitle</p>
</header>
<p>Content</p>
```



## image

```html
<img src="http://placehold.it/100x100.png" alt="image description">
```



## insert

```html
<ins>inserted text</ins>
```



## keyboard

```html
<kbd>user keyboard input</kbd>
```



## list

*… ordered*

```html
<ol>
<li>item</li>
<li>item</li>
<li>item</li>
</ol>
```

*… unordered*

```html
<ul>
<li>item</li>
<li>item</li>
<li>item</li>
</ul>
```



## main

> There must not be more than one `<main>` element in a document.
>
> — [HTML main Tag](https://www.w3schools.com/tags/tag_main.asp)

```html
<main>content unique to the document</main>
```



## marked / highlight

```html
<mark>marked/highlighted text</mark>
```



## page structure

*  [HTML Semantic Elements](https://www.w3schools.com/html/html5_semantic_elements.asp)

```html
<header>header</header>
<nav>nav</nav>
<section>section</section>
<article>article</article>
<aside>aside</aside>
<footer>footer</footer>
```

![layout illustrating the relative page placement of the semantic tags: header, nav, section, article, aside, and footer](semantic-elements.gif)



## sample output

```html
<samp>sample output</samp>
```



## small print

```html
<small>copyright or side-comments</small>
```



## strong

```html
<strong>strong importance</strong>
```



## subscript

```html
<sub>subscript</sub>
```



## superscript

```html
<sup>superscript</sup>
```



## table

```html
<table>
  <tr>
    <th>header cell</th>
    <th>header cell</th>
  </tr>
  <tr>
    <td>value cell</td>
    <td>value cell</td>
  </tr>
</table>
```



## time

*  [<time> - Valid `datetime`Values](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/time#Valid_datetime_Values)

```html
Dinner at <time>20:00</time> on <time datetime="2020-12-31">New Year’s eve</tim>
```



## variable

```html
<var>code or math variable</var>
```



---

