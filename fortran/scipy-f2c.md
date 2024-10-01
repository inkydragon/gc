# Scipy Fortran code rewrite

[META: FORTRAN Code inventory · Issue #18566](https://github.com/scipy/scipy/issues/18566)

## fortran code list

- [ ] `scipy.integrate`:
  - [ ] `dop`:
    - `scipy\integrate\dop\dop853.f`: 879 lines, explicit runge-kutta method of order 8(5,3)
    - `scipy\integrate\dop\dopri5.f`: 879 lines, explicit runge-kutta method of order (4)5
  - [ ] `odepack`: 10,388 lines, 
  - [x] `quadpack`: 8,459 lines, [ENH:integrate: Rewrite QUADPACK in C #21201](https://github.com/scipy/scipy/pull/21201)
- [ ] `scipy.interpolate`
  - [ ] `fitpack`: 18,909	lines
- [ ] `scipy.io`: SKIP
- [ ] `scipy.linalg`
  - [x] `lu.f`: 185 lines
  - [x] `det.f`: 149 lines
  - [x] `id_dist`: 15,406 lines
    [ENH: linalg: Cythonize `id_dist` FORTRAN code #20558](https://github.com/scipy/scipy/pull/20558)
  - [ ] `blas`
  - [ ] `lapack`
- [ ] `scipy.odr`
  - [ ] `odrpack`: 12,990 lines
- [ ] `scipy.optimize`
  - TODO.
- [ ] `scipy.sparse.linalg`
  - [ ] `ARPACK`: 33,640 lines,
  - [x] `iterative`: 2,790 lines,
    [MAINT:ENH:sparse.linalg: Rewrite iterative solvers in Python, remove FORTRAN code #18488](https://github.com/scipy/scipy/pull/18488)
  - [ ] `PROPACK`: 13,164 lines,
- [x] `scipy.special`
  - [x] `AMOS`: 7,233 lines,
    [ENH:MAINT:special:Rewrite amos F77 code #19587](https://github.com/scipy/scipy/pull/19587)
  - [x] `cdflib`: 8,818 lines,
    [ENH:MAINT:special:Cythonize cdflib #19560](https://github.com/scipy/scipy/pull/19560)
  - [x] `specfun`: 12,326 lines,
    [ENH:Rewrite specfun F77 code in C #19824](https://github.com/scipy/scipy/pull/19824)
- [x] `scipy.stats`
  - [x] `statlib`: 706 lines,
    [MAINT:stats:Cythonize and remove Fortran statlib code #18679](https://github.com/scipy/scipy/pull/18679)
  - [ ] `mvndst`: 1206 lines,
