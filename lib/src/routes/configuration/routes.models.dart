/// Retype of String to difference to String
typedef StringPath = String;

/// Force reload param name
const String forceReloadParamName = 'forceReload';

extension StringPathExtensions on StringPath {
  /// Return path with force reload request
  String forceReload() {
    return this.addQueryParamString(
      forceReloadParamName,
      DateTime.now().toUtc().millisecondsSinceEpoch.toString()
    );
  }

  /// Adds query param to current path
  String addQueryParam(RoutesParam routeParam) {
    // Skip empty null value
    if (routeParam.paramValue?.isEmpty ?? true) {
      return this;
    }

    return this.addQueryParamString(
      routeParam.paramName,
      routeParam.paramValue!
    );
  }

  /// Adds query param to current path
  String addQueryParamString(String paramName, String paramValue) {
    final uri = Uri.parse(this);
    // Combine existing query parameters with the new ones.
    final updatedUri = uri.replace(queryParameters: {
      ...uri.queryParameters,
      paramName: paramValue
    });

    return updatedUri.toString();
  }
}

/// Joins the path
String naJoinPaths(String? pathA, String? pathB) {
  if (pathA?.isEmpty ?? true) {
    return pathB ?? '';
  }
  if (pathB?.isEmpty ?? true) {
    return pathA!;
  }
  if (pathA!.endsWith('/') || pathB!.startsWith('/')) {
    return pathA + pathB!;
  }

  return '$pathA/$pathB';
}

/// Joins the path list
String joinPathList(Iterable<String?> pathList) {
  return pathList.reduce(naJoinPaths) ?? '';
}

class NaRoutesPath {
  final String path;
  final bool isFixed;
  final Object? replaceWith;

  NaRoutesPath(this.path, {
    this.isFixed = false,
    this.replaceWith
  });

  factory NaRoutesPath.fix(String path) {
    return NaRoutesPath(path, isFixed: true);
  }
}

class RoutesParam {
  final String paramName;
  final String? paramValue;

  RoutesParam(
    this.paramName,
    this.paramValue
  );
}

class NaRoutesConfiguration {
  final NaRoutesConfiguration? parent;
  /// Paths of the route
  final List<NaRoutesPath> paths;
  /// Paths of the route
  final List<RoutesParam> params;

  NaRoutesConfiguration(this.parent, this.paths, { this.params = const [] });

  @override
  String toString() {
    return this.fullPath;
  }

  /// Return relative path without parameters
  StringPath get relativePath {
    Iterable<String> pathList = this.paths
      .map((NaRoutesPath path) {
        if (path.isFixed) {
          return path.path;
        }
        return path.replaceWith?.toString();
      })
      .where((String? path) => path?.isNotEmpty ?? false)
      .map((String? path) => path!)
    ;

    // Create relative path
    String? relativePath = pathList.isEmpty
      ? null
      : pathList.reduce((String? fullPath, String? currentPath) => naJoinPaths(fullPath, currentPath!))
    ;

    return relativePath ?? '';
  }

  /// Return [navigationPath] with [parent] [fullPath]
  StringPath get fullPath {
    // Create relative path
    String? relativePath = this.relativePath;

    String pathWithoutParams;
    if (relativePath.isEmpty) {
      pathWithoutParams = this.parent?.fullPath ?? '';
    }else {
      pathWithoutParams = naJoinPaths(this.parent?.fullPath, relativePath);
    }

    // Add params
    for (RoutesParam param in this.params) {
      pathWithoutParams = pathWithoutParams.addQueryParam(param);
    }
    return pathWithoutParams;
  }

  /// Return [routePath]
  String get routePath {
    // Create relative path
    String relativeRoutePath = this.paths
      .map((NaRoutesPath path) => path.path)
      .where((String path) => path.isNotEmpty)
      .reduce((String? fullPath, String currentPath) => naJoinPaths(fullPath, currentPath))
    ;
    return relativeRoutePath;
  }
}
