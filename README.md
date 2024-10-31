# test-arm-runner-for-cge

Test GitHubActions [arm-runner](https://github.com/marketplace/actions/arm-runner) action, to

- build [Castle Game Engine](https://castle-engine.io/) application
- on Raspberry Pi
- using GH-hosted runners (so, for free).

The test project inside `test_project_for_rpi` subdirectory is a trivial [Castle Game Engine](https://castle-engine.io/) application (from _"3D FPS Game"_ template for new project) customized to show some system info on startup,

- OS,
- CPU,
- kernel (from `uname` output),
- Linux distro name (from `lsb_release` output).

The test project should actually compile on any system (Raspberry Pi or not). It is for FPC only (not Delphi in this case, as we use FPC `Process` unit, and Delphi cannot compile for Raspberry Pi anyway so the test wouldn't be useful).

## License

License: Permissive modified BSD (3-clause), just like CGE examples, see https://castle-engine.io/license .

Copyright: _Michalis Kamburelis_.
