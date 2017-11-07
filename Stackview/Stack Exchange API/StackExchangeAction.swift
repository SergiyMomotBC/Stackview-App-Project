//
//  StackExchangeAction.swift
//  Stackview
//
//  Created by Sergiy Momot on 10/12/17.
//  Copyright © 2017 Sergiy Momot. All rights reserved.
//

enum StackExchangeAction {
    case upvoteQuestion(id: Int)
    case undoQuestionUpvote(id: Int)
    case downvoteQuestion(id: Int)
    case undoQuestionDownvote(id: Int)
    case deleteQuestion(id: Int)
    case favoriteQuestion(id: Int)
    case undoQuestionFavorite(id: Int)
    case upvoteAnswer(id: Int)
    case undoAnswerUpvote(id: Int)
    case downvoteAnswer(id: Int)
    case undoAnswerDownvote(id: Int)
    case deleteAnswer(id: Int)
    case acceptAnswer(id: Int)
    case undoAnswerAccept(id: Int)
    case upvoteComment(id: Int)
    case undoCommentUpvote(id: Int)
    case deleteComment(id: Int)
    
    var endpoint: String {
        switch self {
        case .upvoteQuestion(let id):
            return "questions/\(id)/upvote"
        case .undoQuestionUpvote(let id):
            return "questions/\(id)/upvote/undo"
        case .downvoteQuestion(let id):
            return "questions/\(id)/downvote"
        case .undoQuestionDownvote(let id):
            return "questions/\(id)/downvote/undo"
        case .deleteQuestion(let id):
            return "questions/\(id)/delete"
        case .favoriteQuestion(let id):
            return "questions/\(id)/favorite"
        case .undoQuestionFavorite(let id):
            return "questions/\(id)/favorite/undo"
        case .upvoteAnswer(let id):
            return "answers/\(id)/upvote"
        case .undoAnswerUpvote(let id):
            return "answers/\(id)/upvote/undo"
        case .downvoteAnswer(let id):
            return "answers/\(id)/downvote"
        case .undoAnswerDownvote(let id):
            return "answers/\(id)/downvote/undo"
        case .deleteAnswer(let id):
            return "answers/\(id)/delete"
        case .acceptAnswer(let id):
            return "answers/\(id)/accept"
        case .undoAnswerAccept(let id):
            return "answers/\(id)/accept/undo"
        case .upvoteComment(let id):
            return "comments/\(id)/upvote"
        case .undoCommentUpvote(let id):
            return "comments/\(id)/upvote/undo"
        case .deleteComment(let id):
            return "comments/\(id)/delete"
        }
    }
}
