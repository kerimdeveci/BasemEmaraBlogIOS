//
//  ListPostsModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-10-02.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import SwiftyPress

enum ListPostsModels {
    
    struct FetchPostsRequest {
        
    }
    
    struct FetchPostsByTermsRequest {
        let ids: Set<Int>
    }
    
    struct PostsResponse {
        let posts: [PostType]
        let media: [MediaType]
    }
}
