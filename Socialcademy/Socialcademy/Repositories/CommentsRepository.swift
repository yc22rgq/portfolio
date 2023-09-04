//
//  CommentsRepository.swift
//  Socialcademy
//
//  Created by Эдуард Кудянов on 17.08.23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - CommentsRepositoryProtocol

protocol CommentsRepositoryProtocol {
    var user: User { get }
    var post: Post { get }
    func fetchComments() async throws -> [Comment]
    func create(_ comment: Comment) async throws
    func delete(_ comment: Comment) async throws
}

extension CommentsRepositoryProtocol {
    func canDelete(_ comment: Comment) -> Bool {
        [comment.author.id, post.author.id].contains(user.id)
    }
}

// MARK: - CommentsRepositoryStub

#if DEBUG
struct CommentsRepositoryStub: CommentsRepositoryProtocol {
    let state: Loadable<[Comment]>
    let user = User.testUser
    let post = Post.testPost
    
    func fetchComments() async throws -> [Comment] {
        return try await state.simulate()
    }
    
    func create(_ comment: Comment) async throws {}
    
    func delete(_ comment: Comment) async throws {}
}
#endif

// MARK: - CommentsRepository

struct CommentsRepository: CommentsRepositoryProtocol {
    let user: User
    let post: Post
    
    private var commentsReference: CollectionReference {
        let postsReference = Firestore.firestore().collection("posts_v2")
        let document = postsReference.document(post.id.uuidString)
        return document.collection("comments")
    }
    
    func fetchComments() async throws -> [Comment] {
        return try await commentsReference
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Comment.self)
    }
    
    func create(_ comment: Comment) async throws {
        let document = commentsReference.document(comment.id.uuidString)
        try await document.setData(from: comment)
    }
    
    func delete(_ comment: Comment) async throws {
        precondition(canDelete(comment))
        let document = commentsReference.document(comment.id.uuidString)
        try await document.delete()
    }
}
