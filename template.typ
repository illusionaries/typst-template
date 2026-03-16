#import "syntaxes.typ": syntax-names

#let typst_title = title

#let template(
  title: "",
  subtitle: "",
  reversed-title-style: false,
  list-markers: ([•], [‣], [–]),
  enum-numbering: "1.",
  doc,
) = {
  set page(paper: "a4", number-align: end, numbering: "1", header: context align(end, {
    let page = counter(page).get().at(0)
    if page != 1 {
      set text(fill: gray, size: 0.75em)
      title
      if (title != "" and subtitle != "") { " · " }
      subtitle
    }
  }))

  set text(font: (
    (name: "Libertinus Serif", covers: "latin-in-cjk"),
    (name: "Source Han Serif SC"),
  ))

  set par(justify: true, spacing: 1.5em)

  show link: set text(fill: blue)
  show link: underline

  show raw: set text(font: "FiraCode Nerd Font")

  show heading: set block(inset: (top: 0.5em, bottom: 0.25em))

  show table.cell.where(y: 0): set text(weight: "bold")
  set table(stroke: (_, y) => if y == 0 { (bottom: black + 0.5pt) })
  set table.hline(stroke: 0.25pt + gray)
  set table.vline(stroke: 0.25pt + gray)
  show table: set par(justify: false)
  show table.cell: set block(inset: (top: 0.25em, bottom: 0.25em))

  let marker_color = luma(0, 35%)

  set list(marker: level => {
    set text(fill: marker_color)
    list-markers.at(calc.rem(level, list-markers.len()))
  })

  set enum(
    numbering: (..nums) => {
      set text(fill: marker_color)
      numbering(enum-numbering, ..nums)
    },
  )

  show raw.where(block: true): it => {
    block(width: 100%, radius: 5pt, fill: luma(97%), inset: 10pt)[
      #it
      #if it.lang != none {
        let lang = syntax-names.at(it.lang, default: it.lang)
        place(end + top, align(start, text(fill: gray, size: 0.75em, lang)))
      }
    ]
  }

  show figure.caption: set text(fill: luma(75%), size: 0.75em)

  if not reversed-title-style {
    typst_title[
      #title \
      #text(subtitle, size: 14pt, weight: "regular")
    ]
  } else {
    typst_title[
      #text(title, size: 14pt, weight: "regular") \
      #subtitle
    ]
  }

  show math.equation.where(block: true): it => {
    block(width: 100%, inset: 0em, [
      #set align(center)
      #it
    ])
  }

  doc
}

#let subtle = it => text(it, fill: luma(40%), size: 0.9em)

#let todo(body: none) = {
  block(outset: 12pt, fill: rgb("#0000ff"), width: 100%, align(center, {
    set text(fill: rgb("#ff0000"), weight: "black", size: 2em)
    if (body == none) {
      "TODO"
    } else {
      body
    }
  }))
}

#let max-height-image(..args, max-height: 250pt) = {
  layout(size => {
    let temp = image(..args)
    let (height,) = measure(width: size.width, temp)
    if (height <= max-height) {
      temp
    } else {
      image(..args, height: max-height)
    }
  })
}


#let max-width-image(..args, max-width: 250pt) = {
  layout(size => {
    let temp = image(..args)
    let (width,) = measure(height: size.height, temp)
    if (width <= max-width) {
      temp
    } else {
      image(..args, width: max-width)
    }
  })
}
