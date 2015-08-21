//
//  PSArborTouch.h
//  PSArborTouch
//
//  Created by Ed Preston on 4/10/11.
//  Copyright 2015 Preston Software. All rights reserved.
//

#import "ATSystem.h"
#import "ATSystemParams.h"
#import "ATSystemState.h"
#import "ATSystemRenderer.h"

#import "ATEdge.h"
#import "ATNode.h"

/*! \mainpage PSArborTouch
 
 PSArborTouch is a particle / spring physics engine optimised for 2D content 
 layout and eye-catching visual effects.
 
 The goal of PSArborTouch is to build a high-quality physics based graph layout 
 engine designed specifically for the Mac OSX and iOS.  The inspiration / 
 structure comes from [arbor] (https://github.com/samizdatco/arbor), a dynamic 
 and well structured javascript engine for the same purpose.
 
 
 ## Example Projects
 
 This distribution contains several examples that demonstrate the features of 
 PSArborTouch.  This includes those found in arbor.js and a few more that 
 explore other uses.
 
 
 ## Status
 
 _This library is functional but it is still a work in progress, see 
 [issues](https://github.com/epreston/PSArborTouch/issues) and 
 [milestones](https://github.com/epreston/PSArborTouch/issues/milestones)_
 
 PSArborTouch is a drop in solution that uses a GCD to keep the main application
 loop free and responsive.
 
 This project follows the [SemVer](http://semver.org/) standard. The API may 
 change in backwards-incompatible ways before the 1.0 release.
 
 
 ## Documentation
 
 You can generate documentation with [doxygen](http://www.doxygen.org). The 
 example project includes a documentation build target to do this within Xcode.
 For more details, see the 
 [Documentation](https://github.com/epreston/PSArborTouch/wiki/Documentation) 
 page in this projects wiki.
 
 
 ## Contribute
 
 If you'd like to contribute to PSArborTouch, start by forking this repository 
 on GitHub:
 
 http://github.com/epreston/PSArborTouch
 
 The best way to get your changes merged back into core is as follows:
 
 1. Clone down your fork
 2. Create a thoughtfully named topic branch to contain your change
 3. Hack away
 4. Add tests and make sure everything still passes
 5. If you are adding new functionality, document it in the README
 6. Do not change the version number, I will do that on my end
 7. If necessary, rebase your commits into logical chunks, without errors
 8. Push the branch up to GitHub
 9. Send a pull request to the epreston/PSArborTouch project.
 
 
 ## Copyright and License
 
 Copyright 2015 Preston Software.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this work except in compliance with the License.
 You may obtain a copy of the License in the LICENSE file, or at:
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 */
