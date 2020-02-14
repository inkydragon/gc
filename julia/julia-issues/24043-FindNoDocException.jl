subtypes(Exception)[
  map(
    x -> nothing != findfirst("No documentation found.", string(Base.Docs.doc(x))), 
    subtypes(Exception)
  )
]
