---
title: Test-Driven Infrastructure with Chef
author:  Stephen Nelson-Smith
date: 2012-12-31
---

I wasn’t quite sure if I agree with using cucumber for integration testing of configuration management. And after reading the book I still don’t. It’s hard to draw the line where you just test the implementation of the config management framework versus your own business logic. And I think it’s highly dependent on the level of advanced logic in your config management code. Although I definitely have seen code that would benefit from some testing like that. 