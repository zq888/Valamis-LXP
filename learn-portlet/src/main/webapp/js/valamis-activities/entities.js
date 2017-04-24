valamisActivities.module('Entities', function(Entities, valamisActivities, Backbone, Marionette, $, _) {

  var ActivitiesModelService = new Backbone.Service({
    url: path.root,
    sync: {
      'delete': {
        'path': function(model){
          return path.api.activities + model.get('id')
        },
        'data': {},
        'method': 'delete'
      }
    },
    targets: {
      'likeActivity': {
        'path': path.api.valamisActivityLike,
        'data': function (model) {
          return {
            userId: Valamis.currentUserId,
            activityId: model.get('id'),
            courseId: Utils.getCourseId(),
            plid: Utils.getPlid()
          };
        },
        'method': 'post'
      },
      'unlikeActivity': {
        'path': path.api.valamisActivityLike,
        'data': function (model) {
          return {
            userId: Valamis.currentUserId,
            activityId: model.get('id'),
            courseId: Utils.getCourseId(),
            plid: Utils.getPlid()
          };
        },
        'method': 'delete'
      },
      'commentActivity': {
        'path': path.api.valamisActivityComment,
        'data': function (model, options) {
          var params = {
            action: 'CREATE',
            userId: Valamis.currentUserId,
            activityId: model.get('id'),
            content: options.content,
            courseId: Utils.getCourseId(),
            plid: Utils.getPlid()
          };
          return params;
        },
        'method': 'post'
      },
      'deleteComment': {
        'path': path.api.valamisActivityComment,
        'data': function (model, options) {
          var params = {
            action: 'DELETE',
            id: model.get('id'),
            courseId: Utils.getCourseId(),
            plid: Utils.getPlid()
          };
          return params;
        },
        'method': 'post'
      },
      shareActivity: {
        'path': path.api.activities,
        'data': function(model){
          var params =  {
            action: 'SHARELESSON' ,
            packageId: model.get('obj')['id'],
            courseId: Utils.getCourseId(),
            plid: Utils.getPlid()
          };
          return params;
        },
        'method': 'post'
      }
    }
  });

  Entities.ActivitiesModel = Backbone.Model.extend({
    parse: function (response) {
      var currentUserLike = false;
      _.forEach(response['userLiked'], function(item) {
        if (item['id'] === Valamis.currentUserId)
          currentUserLike = true;
      });
      response['currentUserLike'] = currentUserLike;
      return response;
    }
  }).extend(ActivitiesModelService);

  var ActivitiesCollectionService = new Backbone.Service({
    url: '',
    sync: {
      'read': {
        'path': function(collection, options) {
          return options.resPath
        },
        'data':  function (collection, options) {          
          var params = {
            action: 'getActivities',
            courseId: Utils.getCourseId,
            page: options.page,
            count: options.count,
            getMyActivities: options.getMyActivities,
            plid: Utils.getPlid()
          };
          return params;
        },
        'method': 'get'
      }
    }
  });

  Entities.ActivitiesCollection = Backbone.Collection.extend({
    model: Entities.ActivitiesModel
  }).extend(ActivitiesCollectionService);

  var LiferayUserModelService = new Backbone.Service({
    url: path.root,
    sync: {
      'read': {
        'path': function (model, options) {
          return path.api.users + options.userId;
        },
        'data': {
          courseId: Utils.getCourseId(),
          plid: Utils.getPlid()
        },
        'method': 'get'
      }
    },
    targets: {
      'postStatus': {
        'path': path.api.activities,
        'data': function (model, options) {
          var params = {
            action: 'CREATEUSERSTATUS',
            courseId: Utils.getCourseId(),
            content: options.content,
            plid: Utils.getPlid()
          };
          return params;
        },
        'method': 'post'
      }
    }
  });

  Entities.LiferayUserModel = Backbone.Model.extend({
  }).extend(LiferayUserModelService);

  Entities.LiferayUserCollection = Backbone.Collection.extend({
    model: Entities.LiferayUserModel
  });

});